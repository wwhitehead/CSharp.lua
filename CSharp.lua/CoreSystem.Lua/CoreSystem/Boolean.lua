--[[
Copyright 2017 YANG Huan (sy.yanghuan@gmail.com).

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--]]

local System = System
local throw = System.throw
local ArgumentException = System.ArgumentException
local ArgumentNullException = System.ArgumentNullException
local FormatException = System.FormatException

local type = type
local tostring = tostring
local setmetatable = setmetatable

local function compareTo(this, v)
  if this == v then
    return 0
  elseif this == false then
    return -1     
  end
  return 1
end

local falseString = "False"
local trueString = "True"

local function parse(s)
  if s == nil then
    return nil, 1
  end
  s = s:Trim():lower()
  if s == "true" then
    return true
  elseif s == "false" then
    return false
  end
  return nil, 2
end

local Boolean = System.defStc("System.Boolean", {
  default = System.falseFn,
  GetHashCode = System.identityFn,
  Equals = System.equals,
  CompareTo = compareTo,
  ToString = tostring,
  FalseString = falseString,
  TrueString = trueString,
  CompareToObj = function (this, v)
    if v == nil then return 1 end
    if type(v) ~= "boolean" then
      throw(ArgumentException("Arg_MustBeBoolean"))
    end
    return compareTo(this, v)
  end,
  EqualsObj = function (this, v)
    if type(v) ~= "boolean" then
      return false
    end
    return this == v
  end,
  __concat = function (a, b)
    if type(a) == "boolean" then
      return tostring(a) .. b
    else 
      return a .. tostring(b)
    end
  end,
  __tostring = function (this)
    if this then
      return trueString
    end
    return falseString
  end,
  Parse = function (s)
    local v, err = parse(s)
    if v == nil then
      if err == 1 then
        throw(ArgumentNullException()) 
      else
        throw(FormatException())
      end
    end
    return v
  end,
  TryParse = function (s)
    local v = parse(s)
    if v ~= nil then
      return true, v
    end
    return false, false
  end,
  __inherits__ = function (_, T)
    return { System.IComparable, System.IComparable_1(T), System.IConvertible, System.IEquatable_1(T) }
  end
})
debug.setmetatable(false, Boolean)

local ValueType = System.ValueType
local boolMetaTable = setmetatable({ __index = ValueType, __call = Boolean.default }, ValueType)
setmetatable(Boolean, boolMetaTable)