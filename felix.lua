local MY_KEY = 0x06 -- https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes

local Verdana = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 16, bit.bor(16, 32));

-- 안티에임
ffi.cdef([[
    unsigned short GetAsyncKeyState(int key); 

    typedef struct Thread32Entry {
        uint32_t dwSize;
        uint32_t cntUsage;
        uint32_t th32ThreadID;
        uint32_t th32OwnerProcessID;
        long tpBasePri;
        long tpDeltaPri;
        uint32_t dwFlags;
    } Thread32Entry;

    typedef struct Color {
        uint8_t r, g, b, a;
    } Color;

    typedef struct Vector2D {
        float x, y;
    } Vector2D;

    typedef struct Vector {
        float x, y, z;
    } Vector;

    typedef struct Vector4D {
        float x, y, z, w;
    } Vector4D;

    typedef struct RepeatedPtrField {
        void* pArena;
        int nCurrentSize;
        int nTotalSize;
	    void* pRep;
    } RepeatedPtrField;

    typedef struct CMsgVector {
        char pad_0x0[0x8];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        Vector vecValue;
    } CMsgVector;

    typedef struct CInButtonStatePB {
        char pad_0x0[0x8];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        uint64_t nValue;
        uint64_t nValueChanged;
        uint64_t nValueScroll;
    } CInButtonStatePB;

    typedef struct CInButtonState {
        char pad_0x0[0x8];
        uint64_t nValue;
        uint64_t nValueChanged;
        uint64_t nValueScroll;
    } CInButtonState;

    typedef struct CBaseUserCmdPB {
        char pad_0x0[0x8];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        RepeatedPtrField subtickMovesField;
        const char* strMoveCrc;
        CInButtonStatePB* pInButtonState;
        CMsgVector* pViewAngles;
        int32_t nLegacyCommandNumber;
        int32_t nClientTick;
        float flForwardMove;
        float flSideMove;
        float flUpMove;
        int32_t nImpulse;
        int32_t nWeaponSelect;
        int32_t nRandomSeed;
        int32_t nMousedX;
        int32_t nMousedY;
        uint32_t nConsumedServerAngleChanges;
        int32_t nCmdFlags;
        uint32_t nPawnEntityHandle;
    } CBaseUserCmdPB;

    typedef struct CUserCmd {
        char pad_0x0[0x18];
        uint32_t nHasBits;
        uint64_t nCachedBits;
        RepeatedPtrField inputHistoryField;
        CBaseUserCmdPB* pBaseCmd;
        bool bLeftHandDesired;
        bool bIsPredictingBodyShotFX;
        bool bIsPredictingHeadShotFX;
        bool bIsPredictingKillRagdolls;
        int32_t nAttack3StartHistoryIndex;
        int32_t nAttack1StartHistoryIndex;
        int32_t nAttack2StartHistoryIndex;
        CInButtonState nButtons;
        char pad_0x58[0x20];
    } CUserCmd;

    typedef struct CConVar {
        const char* szName;
        struct CConVar* pNext;
        char pad_01[0x10];
        const char* szDescription;
        uint32_t nType;
        uint32_t nRegistered;
        uint32_t nFlags;
        uint32_t m_unk3;
        uint32_t m_nCallbacks;
        uint32_t m_unk4;
        union {
            bool Bool;
            short Int16;
            uint16_t Uint16;
            int Int;
            uint32_t Uint32;
            int64_t Int64;
            uint64_t Uint64;
            float Float;
            double Double;
            const char* String;
            struct Color Color;
            struct Vector2D Vector2D;
            struct Vector Vector3D;
            struct Vector4D Vector4D;
            struct Vector Angles;
        } Value;

        union {
            bool Bool;
            short Int16;
            uint16_t Uint16;
            int Int;
            uint32_t Uint32;
            int64_t Int64;
            uint64_t Uint64;
            float Float;
            double Double;
            const char* String;
            struct Color Color;
            struct Vector2D Vector2D;
            struct Vector Vector3D;
            struct Vector4D Vector4D;
            struct Vector Angles;
        } OldValue;
    } CConVar;
        
    typedef struct CUtlLinkedListElement {
        struct CConVar* element;
        uint16_t iPrevious;
        uint16_t iNext;
    } CUtlLinkedListElement;

    typedef struct CUtlMemory {
        struct CUtlLinkedListElement* pMemory;
        int nAllocationCount;
        int nGrowSize;
    } CUtlMemory;
        
    typedef struct CUtlLinkedList {
        struct CUtlMemory memory;
        uint16_t iHead;
        uint16_t iTail;
        uint16_t iFirstFree;
        uint16_t nElementCount;
        uint16_t nAllocated;
        struct CUtlLinkedListElement* pElements;
    } CUtlLinkedList;

    typedef struct IEngineCvar {
        char pad_01[0x40];
        struct CUtlLinkedList listCvars;
    } IEngineCvar;
    
    typedef struct CTraceRay {
        struct Vector vecStart;
        struct Vector vecEnd;
        struct Vector vecMins;
        struct Vector vecMaxs;
        char pad_01[0x5];
    } CTraceRay;

    typedef struct CTraceFilter {
        char pad_01[0x8];
        int64_t nTraceMask;
        int64_t arrUnknown[2];
        int32_t arrSkipHandles[4];
        int16_t arrCollisions[2];
        int16_t nUnknown2;
        uint8_t nUnknown3;
        uint8_t nUnknown4;
        uint8_t nUnknown5;
    } CTraceFilter;
    
    typedef struct CGameTrace {
        void* pSurface;
        void* pHitEntity;
        void* pHitboxData;
        char pad_01[0x38];
        uint32_t nContents;
        char pad_02[0x24];
        struct Vector vecStart;
        struct Vector vecEnd;
        struct Vector vecNormal;
        struct Vector vecPosition;
        char pad_03[0x4];
        float flFraction;
        char pad_04[0x6];
        bool bStartSolid;
        char pad_05[0x4D];
    } CGameTrace;
        
    int CloseHandle(void*);
    void* GetActiveWindow();
    void* GetCurrentProcess();
    uint32_t ResumeThread(void*);
    uint32_t GetCurrentThreadId();
    uint32_t SuspendThread(void*);
    uint32_t GetCurrentProcessId();
    void* GetModuleHandleA(const char*);
    void* GetProcAddress(void*, const char*);
    void* OpenThread(uint32_t, int, uint32_t);
    void* SetWindowLongPtrW(void*, int, void*);
    int Thread32Next(void*, struct Thread32Entry*);
    int Thread32First(void*, struct Thread32Entry*);
    int FlushInstructionCache(void*, void*, uint64_t);
    void* CreateToolhelp32Snapshot(uint32_t, uint32_t);
    typedef void*(*fnCreateInterface)(const char*, void*);
    int VirtualProtect(void*, uint64_t, uint32_t, uint32_t*);
    int64_t CallWindowProcW(void*, void*, uint32_t, uint64_t, int64_t);
]])
local function IsPressed(key)
    return bit.band(ffi.C.GetAsyncKeyState(key), 0x8000) == 0x8000;
end;

local arrHooks = {}
local arrThreads = {}
local arrConvars = {}
local nManualSide = 0
local bYawJitter = false
local arrVirtualKeys = {}
local flYawJitterTick = 0
local bJitterPitch = false
local nPitchJitterTick = 0
local flYawJitterOffset = 0
local NULLPTR = ffi.cast("void*", 0)
local INVALID_HANDLE = ffi.cast("void*", - 1)
local pOriginalWndProc = ffi.cast("void*", 0)
local arrManualStatus = {
    bLeft = false,
    bRight = false,
    bBackWard = false
}

local arrSettings = {
    nLeftKey = 0x5A,--Z
    nRightKey = 0x43,--C
    nBackwardKey = 0x58,--X
    nPitchMode = 0,
    bEnabled = true,
    nYawJitterMode = 0,
    nYawJitterOffset = 20, 
    bDisableInAir = false,
    bForceAirStrafe = true,
    nYawJitterDeltaTick = 3,
    nPitchJitterDeltaTick = 3,
    flPitchRandomMaximized = 89,
    flPitchRandomMinimized = - 89, 

    bEnableArrow = true,
    flCenterOffset = 40,
    clrArrowColor = color_t(0, 255, 255, 255),
    arrManualOffsets = { - 90, 90, 0 }
}
local arrSchema = {
    nFlags = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_fFlags"),
    nHeatlh = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth"),
    nMoveType = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_MoveType"),
    nLifeState = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_lifeState"),
    vecVelocity = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_vecVelocity"),
    flWaterLevel = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_flWaterLevel")
}

local function FindSignature(szModule, szPattern)
    local pBase = find_pattern(szModule, szPattern)
    if ffi.cast("void*", pBase) == NULLPTR then
        return nil
    end
    return ffi.cast("uintptr_t", pBase)
end

local fnCreateFilter = ffi.cast("void(__fastcall*)(struct CTraceFilter&, void*, uint64_t, uint8_t, uint16_t)", assert(FindSignature("client.dll", "48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20 0F B6 41 37 33"), "custom viewmodel error: outdated signature"))
local fnTraceShape = ffi.cast("bool(__fastcall*)(void*, struct CTraceRay*, struct Vector*, struct Vector*, struct CTraceFilter*, struct CGameTrace*)", assert(FindSignature("client.dll", "48 89 5C 24 20 48 89 4C 24 08 55 56 41 55 41 56"), "custom viewmodel error: invalidate signature"))
local fnCreateMove = assert(FindSignature("client.dll", "E9 ?? ?? ?? ?? 0F ?? ?? 48 8B C4 44 88 40"), "antiaim error: outdated signature")
local fnGetUserCmd = ffi.cast("CUserCmd*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "40 53 48 83 EC 20 8B DA 85 D2 78 3C E8 7F"), "antiaim error: outdated signature"))
local fnGetUserCmdArray = ffi.cast("void*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "48 89 4C 24 08 41 54 41 57 48 83 EC 48 4C 63 E2"), "antiaim error: outdated signature"))
local fnGetCommandIndex = ffi.cast("void*(__fastcall*)(void*, int*)", assert(FindSignature("client.dll", "40 53 48 83 EC 20 4C 8B 41 10 48 8B DA 48 8B 0D"), "antiaim error: outdated signature"))
local fnGetViewAngles = ffi.cast("struct Vector*(__fastcall*)(void*, int)", assert(FindSignature("client.dll", "4C 8B C1 85 D2 74 08 48 8D 05 ?? ?? ?? ?? C3"), "antiaim error: outdated signature"))
ffi.metatype("struct CConVar", {
    __index = {
        int = function(this, nValue)
            if nValue then
                local nPrevValue = this.Value.Int
                this.Value.Int = nValue
                return nPrevValue
            end

            return this.Value.Int
        end,

        bool = function(this, bValue)
            if bValue ~= nil then
                local bPrevValue = this.Value.Bool
                this.Value.Bool = bValue
                return bPrevValue
            end

            return this.Value.bValue
        end,

        float = function(this, flValue)
            if flValue then
                local flPrevValue = this.Value.Float
                this.Value.Float = flValue
                return flPrevValue
            end

            return this.Value.Float
        end,

        string = function(this, szValue)
            if szValue then
                local szPrevValue = this.Value.String
                this.Value.String = szValue
                return ffi.string(szPrevValue)
            end

            return ffi.string(this.Value.String)
        end
    }
})

ffi.metatype("struct IEngineCvar", {
    __index = function(self, szName)
        if arrConvars[szName] then
            return arrConvars[szName]
        end

        local listCvar = self.listCvars
        for nIndex = 0, listCvar.memory.nAllocationCount - 1 do
            local pConVar = listCvar.memory.pMemory[nIndex].element
            if not pConVar then
                goto continue
            end

            if szName == ffi.string(pConVar.szName) then
                arrConvars[szName] = pConVar
                return pConVar
            end

            ::continue::
        end

        return false
    end
})

local IEngineCvar = ffi.cast("struct IEngineCvar*", ffi.cast("fnCreateInterface",
    ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("tier0.dll"), "CreateInterface")
)("VEngineCvar007", nil))

local pInstance = (function()
    local pBase = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? E8 ?? ?? ?? ?? 48 8B CF 4C 8B E8"), "anti-aim: outdated signature")
    return ffi.cast("void**", pBase + 7 + ffi.cast("int*", pBase + 3)[0])[0]
end)()

local pUnknownInstance = (function()
    local pBase = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? 8B D3 E8 ?? ?? ?? ?? 44 8B 86 48 12"), "anti-aim: outdated signature")
    return ffi.cast("void**", pBase + 7 + ffi.cast("int*", pBase + 3)[0])[0]
end)()

local function DegToRad(flDegree)
    return flDegree * math.pi / 180
end

local function Clamp(flValue, flMin, flMax)
    return math.max(flMin, math.min(flValue, flMax))
end

local function GetXButtonWParam(wParam)
    return bit.band(ffi.cast("uint16_t", bit.rshift(ffi.cast("uint64_t", wParam), 16)), 0xFFFF)
end

local function IsKeyDown(nVirtualKey)
    if arrVirtualKeys[nVirtualKey] == nil then
        arrVirtualKeys[nVirtualKey] = false
    end

    return arrVirtualKeys[nVirtualKey]
end

local function GetViewAngles()
    local vecViewAngles = fnGetViewAngles(pUnknownInstance, 0)
    return vec3_t(vecViewAngles.x, vecViewAngles.y, vecViewAngles.z)
end

local function Forward(vecAngles)
    local vecSin = vec3_t(math.sin(DegToRad(vecAngles.x)), math.sin(DegToRad(vecAngles.y)), 0)
    local vecCos = vec3_t(math.cos(DegToRad(vecAngles.x)), math.cos(DegToRad(vecAngles.y)), 0)
    return vec3_t(vecCos.x * vecCos.y, vecCos.x * vecSin.y, - vecSin.x)
end

local function Right(vecAngles)
    local vecSin = vec3_t(math.sin(DegToRad(vecAngles.x)), math.sin(DegToRad(vecAngles.y)), math.sin(DegToRad(vecAngles.z)))
    local vecCos = vec3_t(math.cos(DegToRad(vecAngles.x)), math.cos(DegToRad(vecAngles.y)), math.cos(DegToRad(vecAngles.z)))
    return vec3_t(vecSin.z * vecSin.x * vecCos.y * - 1 + vecCos.z * vecSin.y, vecSin.z * vecSin.x * vecSin.y * - 1 + - 1 * vecCos.z * vecCos.y, - 1 * vecSin.z * vecCos.x)
end

local function Up(vecAngles)
    local vecSin = vec3_t(math.sin(DegToRad(vecAngles.x)), math.sin(DegToRad(vecAngles.y)), math.sin(DegToRad(vecAngles.z)))
    local vecCos = vec3_t(math.cos(DegToRad(vecAngles.x)), math.cos(DegToRad(vecAngles.y)), math.cos(DegToRad(vecAngles.z)))
    return vec3_t(vecCos.z * vecSin.x * vecCos.y + vecSin.z * vecSin.y, vecCos.z * vecSin.x * vecSin.y + vecSin.z * vecCos.y * - 1, vecCos.z * vecCos.x)
end

local function GetField(pEntity, szName, szType)
    if not pEntity or pEntity == NULLPTR then
        return false
    end

    if not arrSchema[szName] then
        return false
    end

    return ffi.cast(("%s*"):format(szType), ffi.cast("uintptr_t", pEntity) + arrSchema[szName])[0]
end

local function IsAlive(pEntity)
    if not pEntity or pEntity == NULLPTR then
        return false
    end

    local nHealth = GetField(pEntity, "nHeatlh", "int")
    local nLifeState = GetField(pEntity, "nLifeState", "uint8_t")
    return nLifeState == 0 and nHealth > 0
end

local function Thread(nTheardID)
    local hThread = ffi.C.OpenThread(0x0002, 0, nTheardID)
    if hThread == NULLPTR or hThread == INVALID_HANDLE then
        return false
    end

    return setmetatable({
        bValid = true,
        nId = nTheardID,
        hThread = hThread,
        bIsSuspended = false
    }, {
        __index = {
            Suspend = function(self)
                if self.bIsSuspended or not self.bValid then
                    return false
                end

                if ffi.C.SuspendThread(self.hThread) ~= - 1 then
                    self.bIsSuspended = true
                    return true
                end

                return false
            end,

            Resume = function(self)
                if not self.bIsSuspended or not self.bValid then
                    return false
                end

                if ffi.C.ResumeThread(self.hThread) ~= - 1 then
                    self.bIsSuspended = false
                    return true
                end

                return false
            end,

            Close = function(self)
                if not self.bValid then
                    return
                end

                self:Resume()
                self.bValid = false
                ffi.C.CloseHandle(self.hThread)
            end
        }
    })
end

local function UpdateThreadList()
    arrThreads = {}
    local hSnapShot = ffi.C.CreateToolhelp32Snapshot(0x00000004, 0)
    if hSnapShot == INVALID_HANDLE then
        return false
    end

    local pThreadEntry = ffi.new("struct Thread32Entry[1]")
    pThreadEntry[0].dwSize = ffi.sizeof("struct Thread32Entry")
    if ffi.C.Thread32First(hSnapShot, pThreadEntry) == 0 then
        ffi.C.CloseHandle(hSnapShot)
        return false
    end

    local nCurrentThreadID = ffi.C.GetCurrentThreadId()
    local nCurrentProcessID = ffi.C.GetCurrentProcessId()
    while ffi.C.Thread32Next(hSnapShot, pThreadEntry) > 0 do
        if pThreadEntry[0].dwSize >= 20 and pThreadEntry[0].th32OwnerProcessID == nCurrentProcessID and pThreadEntry[0].th32ThreadID ~= nCurrentThreadID then
            local hThread = Thread(pThreadEntry[0].th32ThreadID)
            if not hThread then
                for _, pThread in pairs(arrThreads) do
                    pThread:Close()
                end

                arrThreads = {}
                ffi.C.CloseHandle(hSnapShot)
                return false
            end

            table.insert(arrThreads, hThread)
        end
    end

    ffi.C.CloseHandle(hSnapShot)
    return true
end

local function SuspendThreads()
    if not UpdateThreadList() then
        return false
    end

    for _, hThread in pairs(arrThreads) do
        hThread:Suspend()
    end

    return true
end

local function ResumeThreads()
    for _, hThread in pairs(arrThreads) do
        hThread:Resume()
        hThread:Close()
    end
end

local function CreateHook(pTarget, pDetour, szType)
    assert(type(pDetour) == "function", "antiaim error: invalid detour function")
    assert(type(pTarget) == "cdata" or type(pTarget) == "userdata" or type(pTarget) == "number" or type(pTarget) == "function", "antiaim error: invalid target function")
    if not SuspendThreads() then
        ResumeThreads()
        print("antiaim error: failed suspend threads")
        return false
    end

    local arrBackUp = ffi.new("uint8_t[14]")
    local pTargetFn = ffi.cast(szType, pTarget)
    local arrShellCode = ffi.new("uint8_t[14]", {
        0xFF, 0x25, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    })

    local __Object = {
        bValid = true,
        bAttached = false,
        pBackup = arrBackUp,
        pTarget = pTargetFn,
        pOldProtect = ffi.new("uint32_t[1]"),
        hCurrentProcess = ffi.C.GetCurrentProcess()
    }

    ffi.copy(arrBackUp, pTargetFn, ffi.sizeof(arrBackUp))
    ffi.cast("uintptr_t*", arrShellCode + 0x6)[0] = ffi.cast("uintptr_t", ffi.cast(szType, function(...)
        local bSuccessfully, pResult = pcall(pDetour, __Object, ...)
        if not bSuccessfully then
            __Object:Remove()
            print(("[antiaim]: unexception runtime error -> %s"):format(pResult))
            return pTargetFn(...)
        end

        return pResult
    end))

    __Object.__index = setmetatable(__Object, {
        __call = function(self, ...)
            if not self.bValid then
                return nil
            end

            self:Detach()
            local bSuccessfully, pResult = pcall(self.pTarget, ...)
            if not bSuccessfully then
                self.bValid = false
                print(("[antiaim]: runtime error -> %s"):format(pResult))
                return nil
            end

            self:Attach()
            return pResult
        end,

        __index = {
            Attach = function(self)
                if self.bAttached or not self.bValid then
                    return false
                end

                self.bAttached = true
                ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), 0x40, self.pOldProtect)
                ffi.copy(self.pTarget, arrShellCode, ffi.sizeof(arrBackUp))
                ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), self.pOldProtect[0], self.pOldProtect)
                return true
            end,

            Detach = function(self)
                if not self.bAttached or not self.bValid then
                    return false
                end

                self.bAttached = false
                ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), 0x40, self.pOldProtect)
                ffi.copy(self.pTarget, self.pBackup, ffi.sizeof(arrBackUp))
                ffi.C.VirtualProtect(self.pTarget, ffi.sizeof(arrBackUp), self.pOldProtect[0], self.pOldProtect)
                return true
            end,

            Remove = function(self)
                if not self.bValid then
                    return false
                end

                SuspendThreads()
                self:Detach()
                ResumeThreads()
                self.bValid = false
            end
        }
    })

    __Object:Attach()
    table.insert(arrHooks, __Object)
    ResumeThreads()
    return __Object
end

local function NormalizePitch(flPitch)
	while flPitch > 89 do
		flPitch = flPitch - 180
	end

	while flPitch < - 89 do
		flPitch = flPitch + 180
	end

	return flPitch
end

local function NormalizeYaw(flYaw)
	while flYaw > 180 do
		flYaw = flYaw - 360
	end

	while flYaw < - 180 do
		flYaw = flYaw + 360
	end

	return flYaw
end

local function NormalizeAngles(vecAngles)
    vecAngles.x = NormalizePitch(vecAngles.x)
    vecAngles.y = NormalizeYaw(vecAngles.y)
    vecAngles.z = 0
    return vecAngles
end

local function CalculateDelta(flSpeed)
    local flMaxSpeed = 300
    local flAirAccelerate = IEngineCvar["sv_airaccelerate"]:float()
    local flAccelerate = 50 / flAirAccelerate / flMaxSpeed * 100 / flSpeed
    if flAccelerate < 1 and flAccelerate > - 1 then
        return math.acos(flAccelerate)
    end

    return 0
end

local function CalculateAngleDelta(flAngles, flTarget)
    local flDelta = flAngles - flTarget
    local flRadius = math.fmod(flDelta, math.pi * 2)
    if flAngles > flTarget then
        if flRadius >= math.pi then
            flRadius = flRadius - math.pi * 2
        end
    else
        if flRadius <= - math.pi then
            flRadius = flRadius + math.pi * 2
        end
    end

    return flRadius
end

local function ProcessManualStatus()
	local nPrevManualStatus = nManualSide
	local bPressLeft, bPressRight, bPressBack = IsKeyDown(arrSettings.nLeftKey), IsKeyDown(arrSettings.nRightKey), IsKeyDown(arrSettings.nBackwardKey)
	if bPressLeft == arrManualStatus.bLeft and bPressRight == arrManualStatus.bRight and bPressBack == arrManualStatus.bBackWard then
		return
	end

	arrManualStatus.bLeft, arrManualStatus.bRight, arrManualStatus.bBackWard = bPressLeft, bPressRight, bPressBack
	if (bPressLeft and nPrevManualStatus == 1) or (bPressRight and nPrevManualStatus == 2) or (bPressBack and nPrevManualStatus == 3) then
		nManualSide = 0
		return
	end

	if bPressLeft and nPrevManualStatus ~= 1 then
		nManualSide = 1
	end

	if bPressRight and nPrevManualStatus ~= 2 then
		nManualSide = 2
	end

	if bPressBack and nPrevManualStatus ~= 3 then
		nManualSide = 3
	end
end

local function GetUserCmd()
    local pLocalPlayer = entitylist.get_local_player_controller()
    if not pLocalPlayer then
        return false
    end

    local pCommandIndex = ffi.new("int[1]")
    fnGetCommandIndex(pLocalPlayer[0], pCommandIndex)
    if pCommandIndex[0] == 0 then
        return false
    end

    local nCurrentCommand = pCommandIndex[0] - 1
    local pUserCmdBase = fnGetUserCmdArray(pInstance, nCurrentCommand)
    if pUserCmdBase == NULLPTR then
        return false
    end

    local nSequenceNumber = ffi.cast("int*", ffi.cast("uintptr_t", pUserCmdBase) + 0x5C00)[0]
    if nSequenceNumber <= 0 then
        return false
    end

    local pUserCmd = fnGetUserCmd(pLocalPlayer[0], nSequenceNumber)
    if pUserCmd == NULLPTR then
        return false
    end

    return pUserCmd
end

local function MovementButtonCorrection(pUserCmd)
    local pBaseCmd = pUserCmd.pBaseCmd
    pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 3))
	pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 4))
	pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 9))
	pUserCmd.nButtons.nValue = bit.bxor(pUserCmd.nButtons.nValue, bit.lshift(1, 10))
    if pBaseCmd.flForwardMove > 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 3))
    elseif pBaseCmd.flForwardMove < 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 4))
    end

    if pBaseCmd.flSideMove > 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 9))
    elseif pBaseCmd.flSideMove < 0 then
        pUserCmd.nButtons.nValue = bit.bor(pUserCmd.nButtons.nValue, bit.lshift(1, 10))
    end
end

local function MovementCorrection(pUserCmd, vecAngles)
    local pBaseCmd = pUserCmd.pBaseCmd
    if pBaseCmd == NULLPTR or pBaseCmd.pViewAngles == NULLPTR then
        return
    end

    local vecTarget = vec3_t(0, vecAngles.y, 0)
    local vecCorrection = vec3_t(0, pBaseCmd.pViewAngles.vecValue.y, 0)

    local vecOldUp = Up(vecTarget)
    local vecOldRight = Right(vecTarget)
    local vecOldForward = Forward(vecTarget)

    local vecUp = Up(vecCorrection)
    local vecRight = Right(vecCorrection)
    local vecForward = Forward(vecCorrection)

    vecUp.x = 0
    vecUp.y = 0
    vecRight.z = 0
    vecOldUp.x = 0
    vecOldUp.y = 0
    vecForward.z = 0
    vecOldRight.z = 0
    vecOldForward.z = 0

    local flRollUp = vecUp.z * pBaseCmd.flUpMove
    local flYawSide = vecRight.y * pBaseCmd.flSideMove
    local flPitchSide = vecRight.x * pBaseCmd.flSideMove
    local flYawForward = vecForward.y * pBaseCmd.flForwardMove
    local flPitchForward = vecForward.x * pBaseCmd.flForwardMove

    pBaseCmd.flUpMove = Clamp(vecOldUp.x * flYawSide + vecOldUp.y * flPitchSide + vecOldUp.x * flYawForward + vecOldUp.y * flPitchForward + vecOldUp.z * flRollUp, - 1, 1)
    pBaseCmd.flSideMove = Clamp(vecOldRight.x * flPitchSide + vecOldRight.y * flYawSide + vecOldRight.x * flPitchForward + vecOldRight.y * flYawForward + vecOldRight.z * flRollUp, - 1, 1)
    pBaseCmd.flForwardMove = Clamp(vecOldForward.x * flPitchSide + vecOldForward.y * flYawSide + vecOldForward.x * flPitchForward + vecOldForward.y * flYawForward + vecOldForward.z * flRollUp, - 1, 1)

    MovementButtonCorrection(pUserCmd)
end

local function AutoStrafe(pBaseCmd, flMoveYaw, vecVelocity)
    local flSpeed = vecVelocity:length_2d()
    local flDeltaAir = CalculateDelta(flSpeed)
    if flDeltaAir == 0 then
        return
    end

    local flBestAngle = math.atan2(pBaseCmd.flSideMove, pBaseCmd.flForwardMove)
    local flVelocityAngle = math.atan2(vecVelocity.y, vecVelocity.x) - math.rad(flMoveYaw)

    local flDeltaAngle = CalculateAngleDelta(flVelocityAngle, flBestAngle)
    local flFinalMove = flDeltaAngle < 0 and flVelocityAngle + flDeltaAir or flVelocityAngle - flDeltaAir

    pBaseCmd.flSideMove = math.sin(flFinalMove)
    pBaseCmd.flForwardMove = math.cos(flFinalMove)
end

local function ProcessKey(nMsg, wParam)
    if nMsg == 0x100 then
        arrVirtualKeys[tonumber(wParam)] = true
    elseif nMsg == 0x101 then
        arrVirtualKeys[tonumber(wParam)] = false
    elseif nMsg == 0x201 then
        arrVirtualKeys[0x1] = true
    elseif nMsg == 0x202 then
        arrVirtualKeys[0x1] = false
    elseif nMsg == 0x204 then
        arrVirtualKeys[0x2] = true
    elseif nMsg == 0x205 then
        arrVirtualKeys[0x2] = false
    elseif nMsg == 0x207 then
        arrVirtualKeys[0x4] = true
    elseif nMsg == 0x208 then
        arrVirtualKeys[0x4] = false
    elseif nMsg == 0x20B then
        local nParam = GetXButtonWParam(wParam)
        if nParam == 0x1 then
            arrVirtualKeys[0x5] = true
        elseif nParam == 0x2 then
            arrVirtualKeys[0x6] = true
        end

    elseif nMsg == 0x20C then
        local nParam = GetXButtonWParam(wParam)
        if nParam == 0x1 then
            arrVirtualKeys[0x5] = false
        elseif nParam == 0x2 then
            arrVirtualKeys[0x6] = false
        end
    end
end

local m_pGameSceneNode = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_pGameSceneNode");
local m_pBulletServices = engine.get_netvar_offset("client.dll", "C_CSPlayerPawn", "m_pBulletServices");
local m_vecAbsOrigin = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_vecAbsOrigin");
local m_vecViewOffset = engine.get_netvar_offset("client.dll", "C_BaseModelEntity", "m_vecViewOffset");

local GetEyePos = function(pLocalPawn)
    local GameSceneNode = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pGameSceneNode)[0];
    if not GameSceneNode or GameSceneNode == 0 then return vec3_t(0,0,0) end;
    local vecAbsOrigin = ffi.cast("struct Vector*", ffi.cast("uintptr_t", GameSceneNode) + m_vecAbsOrigin)[0];
    local vecViewOffset = ffi.cast("struct Vector*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_vecViewOffset)[0];
    
    return vec3_t(vecAbsOrigin.x + vecViewOffset.x, vecAbsOrigin.y + vecViewOffset.y, vecAbsOrigin.z + vecViewOffset.z);
end;

local IEngineTrace = (function()
    local pEngineTrace = assert(FindSignature("client.dll", "48 8B 0D ?? ?? ?? ?? 4C 8B C3 66 89 44 24"), "custom viewmodel error: outdated signature")
    return ffi.cast("void**", pEngineTrace + 7 + ffi.cast("int*", pEngineTrace + 3)[0])[0]
end)()

local function TraceShape(vecStart, vecEnd, pSkip)
    local vecFrom = ffi.new("struct Vector[1]")
    local vecFinal = ffi.new("struct Vector[1]")
    local pTraceRay = ffi.new("struct CTraceRay[1]")
    local pFilter = ffi.new("struct CTraceFilter[1]")
    local pGameTrace = ffi.cast("struct CGameTrace*", ffi.new("struct CGameTrace[1]"))
    fnCreateFilter(pFilter[0], pSkip, 0x1C3003, 4, 7)
    for _, szKey in pairs({ "x", "y", "z" }) do
        vecFinal[0][szKey] = vecEnd[szKey]
        vecFrom[0][szKey] = vecStart[szKey]
    end
    fnTraceShape(IEngineTrace, pTraceRay, vecFrom, vecFinal, pFilter, pGameTrace)
    return pGameTrace
end

local a = "0"
local function AntiAim()
    a = "0"
    local pLocalPawn = entitylist.get_local_player_pawn()
    if not pLocalPawn or not IsPressed(MY_KEY) or IsPressed(0x01) or not IsAlive(pLocalPawn[0]) then
        return
    end

    local pUserCmd = GetUserCmd()
    if not pUserCmd then
        return
    end

    local pBaseCmd = pUserCmd.pBaseCmd
    if pBaseCmd == NULLPTR or pBaseCmd.pViewAngles == NULLPTR then
        return
    end

    local nFlags = GetField(pLocalPawn[0], "nFlags", "uint32_t")
    local nMoveType = GetField(pLocalPawn[0], "nMoveType", "uint8_t")
    local flWaterLevel = GetField(pLocalPawn[0], "flWaterLevel", "float")
    local vecVelocity = GetField(pLocalPawn[0], "vecVelocity", "struct Vector")
    if not nFlags or not nMoveType or not vecVelocity then
        return
    end

    if bit.band(pUserCmd.nButtons.nValue, bit.lshift(1, 5)) ~= 0 then
        return
    end

    local bOnGround = bit.band(nFlags, bit.lshift(1, 0)) ~= 0
    if arrSettings.bDisableInAir and not bOnGround then
        return
    end

    ProcessManualStatus()
    local vecCameraAnlges = GetViewAngles();
    local vecEyePos = GetEyePos(pLocalPawn);
    local flAngleDiff = pBaseCmd.pViewAngles.vecValue.y - vecCameraAnlges.y
    local bInSpeed = bit.band(pUserCmd.nButtons.nValue, bit.lshift(1, 16)) ~= 0

    local arrFractions = {
        ["_l"] = 0,
        ["_r"] = 0
    }
    
    for i = vecCameraAnlges.y - 90, vecCameraAnlges.y + 90, 30 do
        if i ~= vecCameraAnlges.y then
            local vecDest = vec3_t(vecEyePos.x + 256 * math.cos(math.rad(i)), vecEyePos.y + 256 * math.sin(math.rad(i)), vecEyePos.z);
            local pTrace = TraceShape(vecEyePos, vecDest, pLocalPawn[0]);
            local side = i < vecCameraAnlges.y and "_l" or "_r"
            arrFractions[side] = arrFractions[side] + pTrace.flFraction
        end
    end

    a = arrFractions._l > arrFractions._r and "<" or ">";
    local flAdd = arrFractions._l > arrFractions._r and -90 or 90;
    pBaseCmd.pViewAngles.vecValue.y = pBaseCmd.pViewAngles.vecValue.y + flAdd;

    local flMoveYaw = NormalizeYaw(vecCameraAnlges.y + flAngleDiff);
    if not bOnGround and not bInSpeed and arrSettings.bForceAirStrafe and nMoveType ~= 8 and nMoveType ~= 9 and flWaterLevel < 2 then
        AutoStrafe(pBaseCmd, flMoveYaw, vec3_t(vecVelocity.x, vecVelocity.y, vecVelocity.z))
    end

    NormalizeAngles(pBaseCmd.pViewAngles.vecValue)
    MovementCorrection(pUserCmd, vec3_t(0, flMoveYaw, 0))
end

local function hkWndProc(hWnd, nMsg, wParam, lParam)
    ProcessKey(nMsg, wParam)
    return ffi.C.CallWindowProcW(pOriginalWndProc, hWnd, nMsg, wParam, lParam)
end

local function hkCreateMove(pObject, pCCSGOInput, nSlot, nActive)
    pObject(pCCSGOInput, nSlot, nActive)
    pcall(function()
        AntiAim()
    end)
end

local function hkUnLoad()
    for _, pObject in pairs(arrHooks) do
        pObject:Remove()
    end

    if pOriginalWndProc ~= NULLPTR then
        local hWnd = ffi.C.GetActiveWindow()
		ffi.C.SetWindowLongPtrW(hWnd, - 4, ffi.cast("void*", pOriginalWndProc))
		pOriginalWndProc = NULLPTR
	end
end

local function hkPresent()
    local pLocalPawn = entitylist.get_local_player_pawn()
    if not pLocalPawn or not IsPressed(MY_KEY) or not IsAlive(pLocalPawn[0]) or a == "0" then
        return
    end

    local vecScreenSize = render.screen_size() / 2
    render.text(a, Verdana, vec2_t((vecScreenSize.x) + (a == ">" and 90 or -90), vecScreenSize.y - 8), color_t(1,1,1,1))
end

local function SetupWndProc()
    if pOriginalWndProc ~= NULLPTR then
        return
    end

    local hWnd = ffi.C.GetActiveWindow()
    local pWndProcProxy = ffi.cast("int64_t(__stdcall*)(void*, uint32_t, uint64_t, int64_t)", hkWndProc)
    pOriginalWndProc = ffi.C.SetWindowLongPtrW(hWnd, - 4, ffi.cast("void*", pWndProcProxy))
end

local function Setup()
    register_callback("unload", hkUnLoad)
    register_callback("paint", hkPresent)
    CreateHook(fnCreateMove, hkCreateMove, "void(__fastcall*)(void*, int, uint8_t)")
end

Setup()

--킬세이

local phrases =
{
	"hi"
}

local counter = 0
register_callback("player_death", function(event)
    local lp = entitylist.get_local_player_controller()
    local attacker = event:get_controller("attacker")
    local target = event:get_controller("userid")
    if attacker == lp and target ~= lp then
        engine.execute_client_cmd("say \"" .. phrases[counter % #phrases + 1] .. "\"")
        counter = counter + 1
    end
end)


--히트로그

local HIT_LOGS = true
local HARM_LOGS = true

local HIT_COLOR = color_t(0, 1, 0, 1)
local HARM_COLOR = color_t(1, 0, 0, 1)

local FONT_SIZE = 1.3 --폰트 사이트
local OFFSET = vec2_t(0, 450) --오프셋
local LIFETIME = 5


local logs = {}
local scope_offsets = {}


local m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName")
local m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase")
local m_bIsScoped = engine.get_netvar_offset("client.dll", "C_CSPlayerPawn", "m_bIsScoped")
local m_iHealth = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth")
local m_lifeState = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_lifeState")


local function GetNetvar(nEntity, nOffset, nType)
    if not nEntity or nEntity == NULLPTR then return nil end
    return ffi.cast(("%s*"):format(nType), nEntity[nOffset])[0]
end

local function IsAlive(entity)
    if not entity or entity == NULLPTR then return false end
    local health = GetNetvar(entity, m_iHealth, "int")
    local lifestate = GetNetvar(entity, m_lifeState, "uint8_t")
    return lifestate == 0 and health > 0
end

local function Lerp(a, b, time)
    return a + (b - a) * time
end

local function CalcCount(text, search)
    local count = 0
    for i = 1, #text do
        if text:sub(i, i) == search then
            count = count + 1
        end
    end
    return count
end

local colors =
{
    ["white"] = color_t(1, 1, 1, 1),
    ["black"] = color_t(0, 0, 0, 1),
    ["hit"] = HIT_COLOR,
    ["harm"] = HARM_COLOR
}

local function PrintLog(text, prefix)
    local lp = entitylist.get_local_player_pawn()
    local lc = entitylist.get_local_player_controller()
    print("[Nixware] \0", colors[prefix])
    local string = text
    local full_text = ""
    local colored_text = {}
    for i = 1, CalcCount(string, "{") do
        local start_prefix = string:find("{")
        local end_prefix = string:find("}")
        local color = string:sub(start_prefix + 1, end_prefix - 1)
        local next_string = string:sub(end_prefix + 1)
        local next_prefix_start = next_string:find("{")
        local new_string = next_prefix_start and next_string:sub(1, next_prefix_start - 1) or next_string
        string = next_string
        print(new_string .. "\0", colors[color])
        full_text = full_text .. new_string
        table.insert(colored_text, { text = new_string, color = colors[color] })
    end
    print("")
    table.insert(logs, 1, { alpha = 0, tick_base = GetNetvar(lc, m_nTickBase, "int") + (LIFETIME / render.frame_time()), full_text = full_text, colored_text = colored_text })
end

local font = render.setup_font("C:/windows/fonts/verdanab.ttf", (11 * FONT_SIZE), 400)

local function Paint()
    local lp = entitylist.get_local_player_pawn()
    local lc = entitylist.get_local_player_controller()
    if not lp or not lc then return end

    local offset = 0
    for i, v in pairs(logs) do
        local tick_base = GetNetvar(lc, m_nTickBase, "int")
        if tick_base < v.tick_base and i <= 10 then
            v.alpha = Lerp(v.alpha, 1, 0.2)
        else
            v.alpha = Lerp(v.alpha, 0, 0.2)
            if v.alpha < 0.1 then
                table.remove(logs, i)
            end
        end

        local text_size = 0
        local ss = render.screen_size()
        local full_size = render.calc_text_size(v.full_text, font).x
        local scoped = false
        if IsAlive(lp) then scoped = GetNetvar(lp, m_bIsScoped, "bool") end
    
        local pos = vec2_t(OFFSET.x, OFFSET.y + offset)

        for k, f in pairs(v.colored_text) do
            f.color.a = v.alpha
            render.text(f.text, font, vec2_t(pos.x + text_size, pos.y), f.color, (11 * FONT_SIZE))
            text_size = text_size + render.calc_text_size(f.text, font).x
        end
        offset = offset + ((16 * FONT_SIZE) * v.alpha)
    end
end


local hitgroups =
{
    [0] = "generic",
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [8] = "neck"
}

local function PlayerHurt(event)
    local lp = entitylist.get_local_player_pawn()
    local lc = entitylist.get_local_player_controller()
    if not lp or not lc then return end

    local attacker = event:get_controller("attacker")
    local aname = "World"
    if attacker then aname = ffi.string(GetNetvar(attacker, m_sSanitizedPlayerName, "char*")) end

    local target = event:get_controller("userid")
    if not target then return end
    local tname = ffi.string(GetNetvar(target, m_sSanitizedPlayerName, "char*"))

    local remaining = event:get_int("health")
    local damage = event:get_int("dmg_health")
    local hitgroup = hitgroups[event:get_int("hitgroup")]
    local fatal = remaining == 0
    local sharm = false

    if attacker == lc and target == lc then
        sharm = true
        aname = "yourself"
    end

    if target == lc then
        local harm = (fatal and "Killed" or "Harmed") .. (sharm and "" or " by")
        hitgroup = hitgroup == "generic" and "" or (" in {harm}%s{white}"):format(hitgroup)
        damage = fatal and "" or (" for {harm}%s"):format(damage)
        remaining = fatal and "" or ("{white} (%s remaining)"):format(remaining)
        PrintLog(("{white}%s {harm}%s{white}%s%s%s"):format(harm, aname, hitgroup, damage, remaining), "harm")
    elseif attacker == lc then
        local hit = fatal and "Killed" or "Hit"
        hitgroup = (hitgroup == "generic" or hitgroup == "gear") and "" or (fatal and " in" or "'s") .. (" {hit}%s{white}"):format(hitgroup)
        damage = fatal and "" or (" for {hit}%s"):format(damage)
        remaining = fatal and "" or ("{white} (%s remaining)"):format(remaining)
        tname = hitgroup == "{white}" and tname or ("%s{white}"):format(tname)
        PrintLog(("{white}%s {hit}%s%s%s%s"):format(hit, tname, hitgroup, damage, remaining), "hit")
    end
end

register_callback("paint", Paint)
register_callback("player_hurt", PlayerHurt)

-- 워터마크 
local COLOR = color_t(0.1, 0.1, 0.1, 0.7)
local BOLD = true

local font = (BOLD and render.setup_font("C:/windows/fonts/verdanab.ttf", 13, 400) or render.setup_font("C:/windows/fonts/verdana.ttf", 13, 400))

local logs = {}
local fps = 0
local wm_length = 0
local full = ""

local function GetNetvar(nEntity, nOffset, nType)
    if not nEntity or nEntity == NULLPTR then return nil end
    return ffi.cast(("%s*"):format(nType), nEntity[nOffset])[0]
end

local function DrawRoundedRect(from, to, color, rounding)
    render.rect(from, to, color, rounding)
end

local function Watermark() 
    local ss = render.screen_size()
    local time = os.date("%H:%M:%S")
    local level = engine.get_level_name()
    local text = ("[ Nixware.cc ]  | %s | %s |"):format(get_user_name(), time, (level == "<empty>" and "" or level))
    local size = render.calc_text_size(text, font)

    render.rect_filled(vec2_t(ss.x - 5 - size.x - 20, 5), vec2_t(ss.x - 5, 5 + size.y + 10), COLOR, 5)
    render.text(text, font, vec2_t(ss.x - 5 - size.x - 10, 5 + 5))
end

local function Paint()
    fps = 1 / render.frame_time()
    Watermark()
end


-- 가짜 킬로그
local Controls = {
    FakeFeed = true, 
    headshot = true,
    assistedflash = true,
    noscope = true,
    wallbang = true, 
    revenge = true, 
    dominated = true,
    inair = true 
}

Controls.headshot = true
Controls.revenge = true

register_callback("player_death", function(event)
    if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
        if Controls["FakeFeed"] then
            if Controls["headshot"] then
                event:set_int("headshot", 1)
            end
            if Controls["assistedflash"] then
                event:set_int("assistedflash", 1)
            end
            if Controls["noscope"] then
                event:set_int("noscope", 1)
            end
            if Controls["wallbang"] then
                event:set_int("penetrated", 4)
            end
            if Controls["revenge"] then
                event:set_int("revenge", 1)
            end
            if Controls["dominated"] then
                event:set_int("dominated", 1)  
            end
            if Controls["inair"] then
                event:set_int("attackerinair", 1)
            end
        end
    end
end)


register_callback("player_death", function(event)
    if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
        if fake_feed_enabled then
            if headshot_enabled then
                event:set_int("headshot", 1);
            end
            if assisted_flash_enabled then
                event:set_int("assistedflash", 1);
            end
            if noscope_enabled then
                event:set_int("noscope", 1);
            end
            if wallbang_enabled then
                event:set_int("penetrated", 4);
            end
            if revenge_enabled then
                event:set_int("revenge", 1);
            end
            if dominated_enabled then
                event:set_int("dominated", 1);
            end
            if in_air_enabled then
                event:set_int("attackerinair", 1);
            end
        end
    end;
end);


--자동구매봇
local main_buy_list_1 = "buy ssg08";  -- SSG08 구매
local grenade_buy_list_1 = "buy smokegrenade";  -- 연막 구매
local grenade_buy_list_2 = "buy hegrenade";  -- 수류탄 구매
local grenade_buy_list_3 = "buy molotov; buy incgrenade";  -- 화염병 구매

local buy_ssg08 = true     -- SSG08 스나
local buy_smoke = true     -- 연막탄
local buy_hegrenade = true -- 수류탄
local buy_molotov = true   -- 화염병

register_callback("round_start", function ()
    if buy_ssg08 == true then
        engine.execute_client_cmd(main_buy_list_1);
    end
    if buy_smoke == true then
        engine.execute_client_cmd(grenade_buy_list_1);
    end

    if buy_hegrenade == true then
        engine.execute_client_cmd(grenade_buy_list_2);
    end

    if buy_molotov == true then
        engine.execute_client_cmd(grenade_buy_list_3);
    end
end);


local minFOV = 90
local maxFOV = 130
local sliderValue = Controls["Slider1"] or 100
sliderValue = math.max(minFOV, math.min(sliderValue, maxFOV))
if Controls["fovchanger"] then
    local m_iDesiredFOV = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_iDesiredFOV")
    local pLocalController = entitylist.get_local_player_controller()
    if pLocalController then
        ffi.cast("int*", pLocalController[m_iDesiredFOV])[0] = sliderValue
    end
else
    local m_iDesiredFOV = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_iDesiredFOV")
    local pLocalController = entitylist.get_local_player_controller()
    if pLocalController then
        ffi.cast("int*", pLocalController[m_iDesiredFOV])[0] = 140
    end
end

--사운드 정의
local custom_sound_kill = "play sounds/ambient/energy/zap1"
local custom_sound_damage = "play sounds/ambient/energy/zap2"
--히트사운드
register_callback("player_death", function(event)
    if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
        engine.execute_client_cmd(custom_sound_kill)
    end
end)

register_callback("player_hurt", function(event)
    if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
        engine.execute_client_cmd(custom_sound_damage)
    end
end)


--총알로그
local COLOR_RIGHT_HERE = color_t(1, 202 / 255, 113 / 255, 0.8)
local KIBIT = false;

xpcall(function()
    ffi.cdef[[
        typedef struct CGlobalVarsBase { // credits: jakebooom
            float m_flRealTime; //0x0000
            int32_t m_iFrameCount; //0x0004
            float m_flAbsoluteFrameTime; //0x0008
            float m_flAbsoluteFrameStartTimeStdDev; //0x000C
            int32_t m_nMaxClients; //0x0010
            char pad_0014[28]; //0x0014
            float m_flIntervalPerTick; //0x0030
            float m_flCurrentTime; //0x0034
            float m_flCurrentTime2; //0x0038
            char pad_003C[20]; //0x003C
            int32_t m_nTickCount; //0x0050
            char pad_0054[292]; //0x0054
            uint64_t m_uCurrentMap; //0x0178
            uint64_t m_uCurrentMapName; //0x0180
        } CGlobalVarsBase;

        typedef struct vec3_t {
            float x, y, z;
        } vec3_t;

        typedef struct bullet_data {
            vec3_t position;
            float time_stamp;
            float expire_time;
        } bullet_data;
    ]];

    local Abs = function(addr, pre, post)
        addr = addr + (pre or 1);
        addr = addr + ffi.sizeof("int") + ffi.cast("int64_t", ffi.cast("int*", addr)[0]);
        addr = addr + (post or 0);
        return addr;
    end;

    local GlobalVarsBase = ffi.cast("struct CGlobalVarsBase**", Abs(ffi.cast("uintptr_t", find_pattern("client.dll", "48 8B 05 ?? ?? ?? ?? 8B 48 04 FF C1")), 3, 0))[0];
    local last_map = "n1zex";

    local UpdateInterface = function ()
        local newMap = engine.get_level_name();
        if newMap ~= last_map then
            GlobalVarsBase = ffi.cast("struct CGlobalVarsBase**", Abs(ffi.cast("uintptr_t", find_pattern("client.dll", "48 8B 05 ?? ?? ?? ?? 8B 48 04 FF C1")), 3, 0))[0];
            last_map = newMap
            return true;
        end;
    end;

    local m_pGameSceneNode = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_pGameSceneNode");
    local m_pBulletServices = engine.get_netvar_offset("client.dll", "C_CSPlayerPawn", "m_pBulletServices");
    local m_vecAbsOrigin = engine.get_netvar_offset("client.dll", "CGameSceneNode", "m_vecAbsOrigin");
    local m_vecViewOffset = engine.get_netvar_offset("client.dll", "C_BaseModelEntity", "m_vecViewOffset");
    local m_iHealth = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth");

    local CUtlMemory = (function()
        return function(T, I)
            I = ffi.typeof(I or "int")
            local MT = {}

            local INVALID_INDEX = -1
            function MT:invalid_index()
                return INVALID_INDEX
            end

            function MT:is_idx_valid(i)
                local x = ffi.cast("long", i)
                return x >= 0 and x < self.m_allocation_count
            end

            MT.iterator_t = ffi.metatype(
                ffi.typeof([[ 
                    struct {
                        $ index; 
                    }
                ]], I),
                {
                    __eq = function(self, it)
                        if ffi.istype(self, it) then
                            return self.index == it.index
                        end
                    end
                }
            )

            function MT:invalid_iterator()
                return MT.iterator_t(self:invalid_index())
            end

            return ffi.metatype(ffi.typeof([[ 
                    struct {
                        $* m_memory; 
                        int m_allocation_count; 
                        int m_grow_size; 
                    } 
                ]], ffi.typeof(T)), {
                __index = function(self, key)
                    print(tostring("max: " ..tostring(#MT)))
                    print(tostring("access: " ..tostring(key)))
                    print(tostring("self.m_memory: " ..tostring(self.m_allocation_count)))
                    if MT[key] then return MT[key] end
                    if type(key) == "number" then
                        if self:is_idx_valid(key) then
                            return self.m_memory[key]
                        else
                            return nil
                        end
                    end
                    return nil
                end
            })
        end
    end)()
    local anton_1 = ffi.typeof("struct {int m_size; $ m_memory;}", CUtlMemory("bullet_data"));
    local CUtlVector = (function()
        local MT = {}

        function MT:count()
            return self.m_size
        end

        function MT:element(i)
            if i > -1 and i < self.m_size then 
                return self.m_memory[i] 
            else
                return nil
            end
        end

        return function(T, A)
            return ffi.metatype(anton_1, {
                __index = function(self, key)
                    if MT[key] then return MT[key] end
                    if type(key) == "number" then 
                        return self:element(key) 
                    end
                    return nil
                end,
                __ipairs = function(self)
                    return function(t, i)
                        i = i + 1
                        local v = t[i]
                        if v then return i, v end
                    end, self, -1
                end
            })
        end
    end)()
    local pBulletData_type = ffi.typeof("$*", CUtlVector("bullet_data"))
    local GetEyePos = function(pLocalPawn)
        local GameSceneNode = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pGameSceneNode)[0];
        if not GameSceneNode or GameSceneNode == 0 then return vec3_t(0,0,0) end;
        local vecAbsOrigin = ffi.cast("struct vec3_t*", ffi.cast("uintptr_t", GameSceneNode) + m_vecAbsOrigin)[0];
        local vecViewOffset = ffi.cast("struct vec3_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_vecViewOffset)[0];

        return vec3_t(vecAbsOrigin.x + vecViewOffset.x, vecAbsOrigin.y + vecViewOffset.y, vecAbsOrigin.z + vecViewOffset.z);
    end;
    local last_count_bullet = 0;
    local Lerp = function(a, b, t)
        return a + (b - a) * t
    end
    local arrImpacts = {};

    local fnProcessImpacts = function ()
        for i,v in ipairs(arrImpacts) do
            local flDelta = 1 - ((GlobalVarsBase.m_flCurrentTime - v.flCurrentTime) / 4);
            local w2s = render.world_to_screen(v.vecPosition);
            local flLength = 8;
            local flOffset = 3;
            local color = color_t(COLOR_RIGHT_HERE.r, COLOR_RIGHT_HERE.g, COLOR_RIGHT_HERE.b, flDelta);
            if (w2s ~= nil and w2s.x and w2s.y) then 
                if (KIBIT) then
                    render.line(vec2_t(w2s.x - 8, w2s.y), vec2_t(w2s.x + 8, w2s.y), color, 3)
                    render.line(vec2_t(w2s.x, w2s.y - 8), vec2_t(w2s.x, w2s.y + 8), color, 3)
                else
                    render.line(vec2_t(w2s.x - flLength, w2s.y - flLength), vec2_t(w2s.x - flOffset, w2s.y - flOffset), color, 1)
                    render.line(vec2_t(w2s.x + flOffset, w2s.y - flOffset), vec2_t(w2s.x + flLength, w2s.y - flLength), color, 1)
                    render.line(vec2_t(w2s.x + flOffset, w2s.y + flOffset), vec2_t(w2s.x + flLength, w2s.y + flLength), color, 1)
                    render.line(vec2_t(w2s.x - flLength, w2s.y + flLength), vec2_t(w2s.x - flOffset, w2s.y + flOffset), color, 1)
                end
            end;
        end;
    end;

    local fnOnPaint = function ()
        if UpdateInterface() then return; end;
        fnProcessImpacts();
        local pLocalPawn = entitylist.get_local_player_pawn()
        if not pLocalPawn or pLocalPawn == 0 or ffi.cast("int*", pLocalPawn[m_iHealth])[0] <= 0 then
            return
        end
    
        local vecEyePosition = GetEyePos(pLocalPawn)
        local pBulletServices = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", pLocalPawn[0]) + m_pBulletServices)[0]
        if not pBulletServices or pBulletServices == 0 then return end
    
        if not pBulletData_type then return end
        local pBulletData = ffi.cast(pBulletData_type, ffi.cast("uintptr_t", pBulletServices) + 0x48)[0]
        if not pBulletData then return end
    
        local maxIterations = 100
        for i = math.min(pBulletData:count(), last_count_bullet + maxIterations), last_count_bullet + 1, -1 do
            local element = pBulletData:element(i - 1)
            if element and element.position then
                table.insert(arrImpacts, {vecPosition = vec3_t(element.position.x, element.position.y, element.position.z), flCurrentTime = GlobalVarsBase.m_flCurrentTime + 4});
            else
                print("л >> " .. tostring(i - 1))
            end
        end
    
        if pBulletData:count() ~= last_count_bullet then 
            last_count_bullet = pBulletData:count()
        end
        goto zov_
        last_count_bullet = 0;
        ::zov_::
    end
    register_callback("paint", fnOnPaint)
end,print);


-- 가짜 신고 채팅

local report_for = "Report for"
local subbmited_report_id = "submitted, report id"
local frequency = 1
local team_message = false
local custom_report_id = ""
local playerNameOffset = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName");
local origControllerOffset = engine.get_netvar_offset("client.dll", "C_CSPlayerPawnBase", "m_hOriginalController");
local teamString = "_team"
if not team_message then teamString = "" end

register_callback("player_death", function(event)
    if event:get_pawn("userid") == entitylist.get_local_player_pawn() then
        if math.random(1,frequency)==1 then
            local attackerPawn = event:get_pawn("attacker");
            local attackerControllerHandle = ffi.cast("int*", attackerPawn[origControllerOffset])[0];
            if not attackerControllerHandle then return; end;
                local attackerMainController = entitylist.get_entity_from_handle(attackerControllerHandle);
                if not attackerMainController then return; end;
                    local attackerName = ffi.string(ffi.cast("char**", attackerMainController[playerNameOffset])[0])
                    if custom_report_id ~= "" then
                        engine.execute_client_cmd(string.format("say%s %s %s %s %s",teamString, report_for, attackerName, subbmited_report_id, custom_report_id))
                    else
                        engine.execute_client_cmd(string.format("say%s %s %s %s %s%s",teamString, report_for, attackerName, subbmited_report_id, tostring(math.random(1000000000,9999999999)), tostring(math.random(100000000,999999999))))
                    end
        end
    end
end)
