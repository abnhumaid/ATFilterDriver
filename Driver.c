#include <ntddk.h>
#include <wdf.h>
#include "Driver.h"
#include "Trace.h"
#include "Driver.tmh"

VOID EvtIoWrite(WDFQUEUE Queue, WDFREQUEST Request, size_t Length) {
    PVOID buffer;
    if (NT_SUCCESS(WdfRequestRetrieveInputBuffer(Request, Length, &buffer, NULL))) {
        if (Length >= 2 && RtlCompareMemory(buffer, "AT", 2) == 2) {
            TraceEvents(TRACE_LEVEL_INFORMATION, TRACE_DRIVER, "AT Command Sent: %s", (char*)buffer);
        }
    }
    WdfRequestComplete(Request, STATUS_SUCCESS);
}

NTSTATUS DriverEntry(PDRIVER_OBJECT DriverObject, PUNICODE_STRING RegistryPath) {
    WDF_DRIVER_CONFIG config;
    WDF_DRIVER_CONFIG_INIT(&config, WDF_NO_EVENT_CALLBACK);
    WPP_INIT_TRACING(DriverObject, RegistryPath);
    NTSTATUS status = WdfDriverCreate(DriverObject, RegistryPath, WDF_NO_OBJECT_ATTRIBUTES, &config, WDF_NO_HANDLE);
    if (!NT_SUCCESS(status)) {
        WPP_CLEANUP(DriverObject);
    }
    return status;
}
