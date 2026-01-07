
-- the main table that acts as the set definition
SET = {}

SET.__index = SET

--constructor, turns SET into a class 
function SET:new(values)
    values = values or {}
    local set = setmetatable({}, SET)

    set.count = #values
    set.values = {}

    for _, v in ipairs(values) do 
            set.values[v] = v
    end
   return set 
end

-- helper function
function SET:to_list()
    local _list = {}
    for k, v in pairs(self.values) do 
        table.insert(_list, v)
    end
    return _list
end 

-- helper function
function SET: __tostring()
    local L = self:to_list()
    return "{" ..table.concat(L, ",") .. "}"
end




--SET METHODS:

--CARDINALITY
function SET:__len()
    --check if count is know
    if self.count > 0 then
        return self.count
    end

    local n = 0
    for _ in pairs(self.values) do n = n + 1 end 

    self.count = n 

    return n
end



-- EQUAL
function SET:__eq(other)

    --test if other is the same object in memory
    if rawequal(self, other) then return true end
    --test if other NOT of type set
    if getmetatable(other) ~= SET then return false end

    --check cardinality
    local c1, c2 = 0, 0

    for _ in pairs(self.values) do c1 = c1+1 end
    for _ in pairs(other.values) do c2 = c2+1 end

    --if the cardinality differs, the the sets are NOT equal by default
    if c1 ~= c2 then
        return false
    end

    --[[ 
        perform mutual inclusion check of equality: If ∣A∣=∣B∣ and A⊆B, then A=B
    --]] 

    for k, _ in pairs(self.values) do
        if other.values[k] == nil then
            return false
        end
    end
    -- non of the checks failed, ergo the sets are equal 
    return true 
end


-- SUBSET 
function SET:subset(other)

    --test if other is the same object in memory
    if rawequal(self, other) then return true end
    --test if other NOT of type set
    if getmetatable(other) ~= SET then return false end

    --if self is an empty set return true
    if #self.values == 0 then return true end

    -- for each element in self (A), check if its in other (B), if an element isn't present in other then its no Subset
    for k, _ in pairs(self.values) do
        if other.values[k] == nil then
            return false --no subset because x in A but x not in B 
        end
    end
    return true
end

--UNION
function SET:union(other)
    --in case of calling the method with .
    if other == nil then
        error("Error: 'other' is nil. check for . vs : confusion")
    end

    local U = SET:new(self:to_list()) --copy all values into a new set
    for k, v in pairs(other.values) do
        if U.values[k] == nil then
            U.values[k] = v 
        end
    end
    return U
end




--INTERSECT
function SET:intersection(other)
    --in case of calling the method with .
    if other == nil then
        error("Error: 'other' is nil. check for . vs : confusion")
    end

    local A, B = nil, nil

    --find smallest 
    if #other < #self then 
        A = other
        B = self
    else
        A = self
        B = other
    
    end

    local N = SET:new() --empty 
    for k,v in pairs(A.values) do
         if B.values[k] and not N.values[k] then
            N.values[k] = v
         end
    end
    return N
end


--OPERANTS
-- Map '+' operator to union
SET.__add = SET.union
-- Map '*' operator to intersection
SET.__mul = SET.intersection
-- Map '<=' operator to subset of
SET.__le  = SET.subset 


-- TESTING (tests are bootstrapped by gemini)
local TEST_COUNT = 0

local A = SET:new({1, 2, 3})
local B = SET:new({3, 4, 5})
local C = SET:new({1, 2})       
local Neg = SET:new({-1, -5, -10}) 
local Mix = SET:new({1, "a", -5})
local Empty = SET:new({})



local function expect(condition, name)
    if condition then
        print(string.format("[PASS] %s", name))
    else
        error(string.format("FAILED: %s", name))
    end
    TEST_COUNT = TEST_COUNT + 1
end


expect(true, "SETUP COMPLETE")

-- 2. CARDINALITY & EQUALITY
expect(#A == 3,      "CARDINALITY A")
expect(#Empty == 0,  "CARDINALITY EMPTY")
expect(A == A,       "EQUALITY REFLEXIVE")
expect(A ~= B,       "INEQUALITY")
expect(SET:new({1,2,1}) == SET:new({1,2}), "DEDUPLICATION")

-- 3. SUBSETS
expect(C <= A,       "SUBSET (C <= A)")
expect(not (A <= C), "SUBSET FALSE (A <= C)")
expect(Empty <= A,   "EMPTY SUBSET")
expect(Neg <= SET:new({-1, -5, -10, 0}), "NEGATIVE SUBSET")

-- 4. UNION (+)
local U_Res = A + B
expect(U_Res == SET:new({1,2,3,4,5}), "UNION BASIC")
expect(A + Empty == A,                "UNION IDENTITY")
expect(A + A == A,                    "UNION IDEMPOTENT")
expect((A + B) == (B + A),            "UNION COMMUTATIVE")

-- 5. INTERSECTION (*)
local I_Res = A * B -- {3}
expect(I_Res == SET:new({3}),         "INTERSECTION BASIC")
expect(A * Empty == Empty,            "INTERSECTION IDENTITY")
expect((A * B) == (B * A),            "INTERSECTION COMMUTATIVE")
expect((A * C) == C,                  "INTERSECTION SUBSET")

-- 6. NEGATIVES & COMPLEX
local ZeroSum = SET:new({1}) + SET:new({-1})
expect(ZeroSum == SET:new({1, -1}),   "NEGATIVE UNION")
expect((Neg * SET:new({-5})) == SET:new({-5}), "NEGATIVE INTERSECTION")

-- 7. CHAINING OPERATIONS
-- (A U B) * C -> {1,2,3,4,5} * {1,2} -> {1,2}
expect(((A + B) * C) == C,            "CHAINING (A+B)*C")
-- (A * B) + C -> {3} + {1,2} -> {1,2,3} (A)
expect(((A * B) + C) == A,            "CHAINING (A*B)+C")

-- 8. MIXED TYPES
local Mix2 = SET:new({"a", "b", 1})
-- Intersection of {1, "a", -5} and {"a", "b", 1} -> {1, "a"}
expect((Mix * Mix2) == SET:new({1, "a"}), "MIXED TYPES")


print("\n--------------------------------")
print("  PASSED  " .. TEST_COUNT .. " CHECKS")
print("--------------------------------")