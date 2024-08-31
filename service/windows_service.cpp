#define WIN32_LEAN_AND_MEAN
#include <WinSock2.h>
#include <Windows.h>
#include <iostream>
#include <string>
#pragma comment(lib, "ws2_32.lib")

SERVICE_STATUS ServiceStatus;
SERVICE_STATUS_HANDLE hstatus;

// for CPU usage
ULARGE_INTEGER lastCPU, lastSysCPU, lastUserCPU;
int numProcessors;
HANDLE self;

// for RAM Usage
MEMORYSTATUSEX memInfo;

void ReportStatus(DWORD state) {
    ServiceStatus.dwCurrentState = state;
    SetServiceStatus(hstatus, &ServiceStatus);
}

void ControlHandler(DWORD request) {
    switch (request) {
    case SERVICE_CONTROL_STOP:
        ReportStatus(SERVICE_STOP_PENDING);
        // Perform any necessary cleanup
        ReportStatus(SERVICE_STOPPED);
        break;
    default:
        break;
    }
}

void InitCPUUsage() {
    SYSTEM_INFO sysInfo;
    FILETIME ftime, fsys, fuser;

    GetSystemInfo(&sysInfo);
    numProcessors = sysInfo.dwNumberOfProcessors;

    GetSystemTimeAsFileTime(&ftime);
    memcpy(&lastCPU, &ftime, sizeof(FILETIME));

    self = GetCurrentProcess();
    GetProcessTimes(self, &ftime, &ftime, &fsys, &fuser);
    memcpy(&lastSysCPU, &fsys, sizeof(FILETIME));
    memcpy(&lastUserCPU, &fuser, sizeof(FILETIME));
}

double GetCPUUsage() {
    FILETIME ftime, fsys, fuser;
    ULARGE_INTEGER now, sys, user;
    double percent;

    GetSystemTimeAsFileTime(&ftime);
    memcpy(&now, &ftime, sizeof(FILETIME));

    GetProcessTimes(self, &ftime, &ftime, &fsys, &fuser);
    memcpy(&sys, &fsys, sizeof(FILETIME));
    memcpy(&user, &fuser, sizeof(FILETIME));

    percent = (double)((sys.QuadPart - lastSysCPU.QuadPart) + (user.QuadPart - lastUserCPU.QuadPart));

    percent /= (now.QuadPart - lastCPU.QuadPart);

    percent /= numProcessors;

    lastCPU = now;
    lastSysCPU = sys;
    lastUserCPU = user;

    return percent * 100;
}

double GetRAMUsage() {
    memInfo.dwLength = sizeof(MEMORYSTATUSEX);
    GlobalMemoryStatusEx(&memInfo);

    DWORDLONG totalPhysMem = memInfo.ullTotalPhys;
    DWORDLONG physMemUsed = memInfo.ullTotalPhys - memInfo.ullAvailPhys;

    // Convert to percentage if needed
    double memUsage = (double)physMemUsed / (double)totalPhysMem * 100;
    std::cout << "RAM Usage: " << memUsage << "%" << std::endl;
    return memUsage;
}

void StartSocketServer() {
    WSADATA wsaData;
    SOCKET serverSocket, clientSocket;
    struct sockaddr_in serverAddr, clientAddr;
    int addrLen = sizeof(clientAddr);

    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        std::cerr << "WSAStartup failed" << std::endl;
        return;
    }

    serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverSocket == INVALID_SOCKET) {
        std::cerr << "Socket creation failed" << std::endl;
        WSACleanup();
        return;
    }

    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    serverAddr.sin_port = htons(8080);

    if (bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) == SOCKET_ERROR) {
        std::cerr << "Bind failed" << std::endl;
        closesocket(serverSocket);
        WSACleanup();
        return;
    }

    if (listen(serverSocket, 3) == SOCKET_ERROR) {
        std::cerr << "Listen failed" << std::endl;
        closesocket(serverSocket);
        WSACleanup();
        return;
    }

    while ((clientSocket = accept(serverSocket, (struct sockaddr*)&clientAddr, &addrLen)) != INVALID_SOCKET) {
        char buffer[1024];
        int bytesRead = recv(clientSocket, buffer, sizeof(buffer), 0);

        if (bytesRead > 0) {
            std::string data = "CPU: " + std::to_string(GetCPUUsage()) + "% RAM: " + std::to_string(GetRAMUsage()) + "%";
            send(clientSocket, data.c_str(), data.size(), 0);
        }
        else if (bytesRead == SOCKET_ERROR) {
            std::cerr << "recv failed" << std::endl;
        }
        closesocket(clientSocket);
    }
    closesocket(serverSocket);
    WSACleanup();
}

void WINAPI ServiceMain(DWORD argc, LPTSTR* argv) {
    hstatus = RegisterServiceCtrlHandler(L"SystemMonitorService", ControlHandler);
    if (!hstatus) {
        return;
    }

    ServiceStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;
    ServiceStatus.dwCurrentState = SERVICE_START_PENDING;
    ServiceStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP;
    ServiceStatus.dwWin32ExitCode = 0;
    ServiceStatus.dwServiceSpecificExitCode = 0;
    ServiceStatus.dwCheckPoint = 0;
    ServiceStatus.dwWaitHint = 0;

    ReportStatus(SERVICE_START_PENDING);

    // Initialize CPU usage
    InitCPUUsage();
    ReportStatus(SERVICE_RUNNING);

    StartSocketServer();

    while (ServiceStatus.dwCurrentState == SERVICE_RUNNING) {
        // Fetch CPU and RAM here and possibly communicate with Flutter app
        double cpuUsage = GetCPUUsage();
        double ramUsage = GetRAMUsage();
        Sleep(1000);
    }

    ReportStatus(SERVICE_STOPPED);
}

int main() {
    SERVICE_TABLE_ENTRY ServiceTable[] = {
        { (LPWSTR)L"SystemMonitorService", (LPSERVICE_MAIN_FUNCTION)ServiceMain },
        { NULL, NULL }
    };


    if (!StartServiceCtrlDispatcher(ServiceTable)) {
        std::cerr << "Service failed to start" << std::endl;
    }

    return 0;
}