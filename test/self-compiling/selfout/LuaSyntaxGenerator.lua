-- Generated by CSharp.lua Compiler 1.0.0.0
local System = System
local Linq = System.Linq.Enumerable
local MicrosoftCodeAnalysis = Microsoft.CodeAnalysis
local MicrosoftCodeAnalysisCSharp = Microsoft.CodeAnalysis.CSharp
local MicrosoftCodeAnalysisCSharpSyntax = Microsoft.CodeAnalysis.CSharp.Syntax
local SystemIO = System.IO
local SystemLinq = System.Linq
local SystemText = System.Text
local CSharpLua
local CSharpLuaLuaAst
System.usingDeclare(function (global) 
    CSharpLua = global.CSharpLua
    CSharpLuaLuaAst = CSharpLua.LuaAst
end)
System.namespace("CSharpLua", function (namespace) 
    namespace.class("PartialTypeDeclaration", function (namespace) 
        local CompareTo
        CompareTo = function (this, other) 
            return #this.CompilationUnit.FilePath:CompareTo(#other.CompilationUnit.FilePath)
        end
        return {
            __inherits__ = function () 
                return {
                    System.IComparable_1(CSharpLua.PartialTypeDeclaration)
                }
            end, 
            CompareTo = CompareTo
        }
    end)
    namespace.class("LuaSyntaxGenerator", function (namespace) 
        namespace.class("SettingInfo", function (namespace) 
            local getIndent, setIndent, __ctor__
            getIndent = function (this) 
                return this.indent_
            end
            setIndent = function (this, value) 
                if value > 0 and this.indent_ ~= value then
                    this.indent_ = value
                    this.IndentString = System.String(32 --[[' ']], this.indent_)
                end
            end
            __ctor__ = function (this) 
                setIndent(this, 4)
                this.HasSemicolon = false
                this.IsNewest = true
            end
            return {
                HasSemicolon = false, 
                indent_ = 0, 
                IsNewest = false, 
                getIndent = getIndent, 
                setIndent = setIndent, 
                __ctor__ = __ctor__
            }
        end)
        local Encoding, Create, Write, Generate, GetOutFilePath, IsEnumExport, AddExportEnum, AddEnumDeclaration, 
        IsExportAttribute, CheckExportEnums, AddPartialTypeDeclaration, CheckPartialTypes, GetSemanticModel, IsBaseType, GetMethodName, IsTypeEnable, 
        AddBaseTypeTo, GetExportTypes, ExportManifestFile, AddTypeSymbol, CheckExtends, TryAddExtend, GetMemberMethodName, InternalGetMemberMethodName, 
        GetSymbolName, GetExtensionMethodName, GetStaticClassMethodName, GetMethodNameFromIndex, TryAddNewUsedName, GetSameNameMembers, MethodSymbolToString, MemberSymbolToString, 
        GetSymbolWright, MemberSymbolCommonComparison, MemberSymbolBoolComparison, MemberSymbolComparison, FillSameNameMembers, CheckRefactorNames, RefactorCurTypeSymbol, RefactorInterfaceSymbol, 
        RefactorName, RefactorChildrensOverridden, UpdateName, GetRefactorName, IsTypeNameUsed, CheckNewNameEnable, __staticCtor__, __init__, 
        __ctor__
        Create = function (this) 
            local luaCompilationUnits = System.List(CSharpLuaLuaAst.LuaCompilationUnitSyntax)()
            for _, syntaxTree in System.each(this.compilation_:getSyntaxTrees()) do
                local semanticModel = GetSemanticModel(this, syntaxTree)
                local compilationUnitSyntax = System.cast(MicrosoftCodeAnalysisCSharpSyntax.CompilationUnitSyntax, syntaxTree:GetRoot(nil))
                local transfor = CSharpLua.LuaSyntaxNodeTransfor:new(1, this, semanticModel)
                local luaCompilationUnit = System.cast(CSharpLuaLuaAst.LuaCompilationUnitSyntax, compilationUnitSyntax:Accept(transfor, CSharpLuaLuaAst.LuaSyntaxNode))
                luaCompilationUnits:Add(luaCompilationUnit)
            end
            CheckExportEnums(this)
            CheckPartialTypes(this)
            CheckRefactorNames(this)
            return Linq.Where(luaCompilationUnits, function (i) 
                return not i:getIsEmpty()
            end)
        end
        Write = function (this, luaCompilationUnit, outFile) 
            System.using(SystemIO.StreamWriter(outFile, false, Encoding), function (writer) 
                local rener = CSharpLua.LuaRenderer(this, writer)
                luaCompilationUnit:Render(rener)
            end)
        end
        Generate = function (this, baseFolder, outFolder) 
            local modules = System.List(System.String)()
            for _, luaCompilationUnit in System.each(Create(this)) do
                local module
                local default
                default, module = GetOutFilePath(this, luaCompilationUnit.FilePath, baseFolder, outFolder, module)
                local outFile = default
                Write(this, luaCompilationUnit, outFile)
                modules:Add(module)
            end
            ExportManifestFile(this, modules, outFolder)
        end
        GetOutFilePath = function (this, inFilePath, folder_, output_, module) 
            local path = inFilePath:Remove(0, #folder_):TrimStart(SystemIO.Path.DirectorySeparatorChar, 47 --[['/']])
            local extend = SystemIO.Path.GetExtension(path)
            path = path:Remove(#path - #extend, #extend)
            path = path:Replace(46 --[['.']], 95 --[['_']])
            local outPath = SystemIO.Path.Combine(output_, (path or "") .. ".lua" --[[LuaSyntaxGenerator.kLuaSuffix]])
            local dir = SystemIO.Path.GetDirectoryName(outPath)
            if not SystemIO.Directory.Exists(dir) then
                SystemIO.Directory.CreateDirectory(dir)
            end
            module = path:Replace(SystemIO.Path.DirectorySeparatorChar, 46 --[['.']])
            return outPath, module
        end
        IsEnumExport = function (this, enumTypeSymbol) 
            return this.exportEnums_:Contains(enumTypeSymbol)
        end
        AddExportEnum = function (this, enumTypeSymbol) 
            this.exportEnums_:Add(enumTypeSymbol)
        end
        AddEnumDeclaration = function (this, enumDeclaration) 
            this.enumDeclarations_:Add(enumDeclaration)
        end
        IsExportAttribute = function (this, attributeTypeSymbol) 
            if this.exportAttributes_ ~= nil then
                if this.exportAttributes_:getCount() > 0 then
                    return this.exportAttributes_:Contains(attributeTypeSymbol:ToString())
                end
                return true
            end
            return false
        end
        CheckExportEnums = function (this) 
            for _, enumDeclaration in System.each(this.enumDeclarations_) do
                if IsEnumExport(this, enumDeclaration.FullName) then
                    enumDeclaration.IsExport = true
                    enumDeclaration.CompilationUnit:AddTypeDeclarationCount()
                end
            end
        end
        AddPartialTypeDeclaration = function (this, typeSymbol, node, luaNode, compilationUnit) 
            local list = CSharpLua.Utility.GetOrDefault1(this.partialTypes_, typeSymbol, nil, MicrosoftCodeAnalysis.INamedTypeSymbol, System.List(CSharpLua.PartialTypeDeclaration))
            if list == nil then
                list = System.List(CSharpLua.PartialTypeDeclaration)()
                this.partialTypes_:Add(typeSymbol, list)
            end
            list:Add(System.create(CSharpLua.PartialTypeDeclaration(), function (default) 
                default.Symbol = typeSymbol
                default.Node = node
                default.TypeDeclaration = luaNode
                default.CompilationUnit = compilationUnit
            end))
        end
        CheckPartialTypes = function (this) 
            while this.partialTypes_:getCount() > 0 do
                local types = Linq.ToArray(this.partialTypes_:getValues())
                this.partialTypes_:Clear()
                for _, typeDeclarations in System.each(types) do
                    local major = Linq.Min(typeDeclarations)
                    local transfor = CSharpLua.LuaSyntaxNodeTransfor:new(1, this, nil)
                    transfor:AcceptPartialType(major, typeDeclarations)
                end
            end
        end
        GetSemanticModel = function (this, syntaxTree) 
            return this.compilation_:GetSemanticModel(syntaxTree, false)
        end
        IsBaseType = function (this, type) 
            local syntaxTree = type:getSyntaxTree()
            local semanticModel = GetSemanticModel(this, syntaxTree)
            local symbol = MicrosoftCodeAnalysisCSharp.CSharpExtensions.GetTypeInfo(semanticModel, type:getType(), nil):getType()
            assert(symbol ~= nil)
            return symbol:getTypeKind() ~= 7 --[[TypeKind.Interface]]
        end
        GetMethodName = function (this, symbol) 
            return GetMemberMethodName(this, symbol)
        end
        IsTypeEnable = function (this, type) 
            if type:getTypeKind() == 5 --[[TypeKind.Enum]] then
                return IsEnumExport(this, type:ToString())
            end
            return true
        end
        AddBaseTypeTo = function (this, parentTypes, rootType, baseType) 
            if CSharpLua.Utility.IsFromCode(baseType) then
                if baseType:getIsGenericType() then
                    parentTypes:Add(baseType:getOriginalDefinition())
                    for _, typeArgument in System.each(baseType:getTypeArguments()) do
                        if typeArgument:getKind() ~= 17 --[[SymbolKind.TypeParameter]] then
                            if not CSharpLua.Utility.IsAssignableFrom(rootType, typeArgument) then
                                local typeArgumentType = System.cast(MicrosoftCodeAnalysis.INamedTypeSymbol, typeArgument)
                                AddBaseTypeTo(this, parentTypes, rootType, typeArgumentType)
                            end
                        end
                    end
                else
                    parentTypes:Add(baseType)
                end
            end
        end
        GetExportTypes = function (this) 
            local allTypes = System.List(MicrosoftCodeAnalysis.INamedTypeSymbol)()
            if #this.types_ > 0 then
                this.types_:Sort(function (x, y) 
                    return x:ToString():CompareTo(y:ToString())
                end)

                local typesList = System.List(System.List(MicrosoftCodeAnalysis.INamedTypeSymbol))()
                typesList:Add(this.types_)

                while true do
                    local parentTypes = System.HashSet(MicrosoftCodeAnalysis.INamedTypeSymbol)()
                    local lastTypes = CSharpLua.Utility.Last(typesList, System.List(MicrosoftCodeAnalysis.INamedTypeSymbol))
                    for _, type in System.each(lastTypes) do
                        if type:getBaseType() ~= nil then
                            AddBaseTypeTo(this, parentTypes, type, type:getBaseType())
                        end

                        for _, interfaceType in System.each(type:getInterfaces()) do
                            AddBaseTypeTo(this, parentTypes, type, interfaceType)
                        end
                    end

                    if parentTypes:getCount() == 0 then
                        break
                    end

                    typesList:Add(Linq.ToList(parentTypes))
                end

                typesList:Reverse()
                local types = Linq.Where(Linq.Distinct(Linq.SelectMany(typesList, function (i) 
                    return i
                end, MicrosoftCodeAnalysis.INamedTypeSymbol)), System.bind(this, IsTypeEnable))
                allTypes:AddRange(types)
            end
            return allTypes
        end
        ExportManifestFile = function (this, modules, outFolder) 
            local kDir = "dir"
            local kDirInitCode = "dir = (dir and #dir > 0) and (dir .. '.') or \"\""
            local kRequire = "require"
            local kLoadCode = "local load = function(module) return require(dir .. module) end"
            local kLoad = "load"
            local kInit = "System.init"
            local kManifestFile = "manifest.lua"

            if #modules > 0 then
                modules:Sort()
                local types = GetExportTypes(this)
                if #types > 0 then
                    local functionExpression = CSharpLuaLuaAst.LuaFunctionExpressionSyntax()
                    functionExpression:AddParameter1(CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, kDir))
                    functionExpression:AddStatement1(CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, kDirInitCode))

                    local requireIdentifier = CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, kRequire)
                    functionExpression:AddStatement(CSharpLuaLuaAst.LuaLocalVariableDeclaratorSyntax:new(2, requireIdentifier, requireIdentifier))

                    functionExpression:AddStatement1(CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, kLoadCode))
                    functionExpression:AddStatement(CSharpLuaLuaAst.LuaBlankLinesStatement.One)

                    local loadIdentifier = CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, kLoad)
                    for _, module in System.each(modules) do
                        local argument = CSharpLuaLuaAst.LuaStringLiteralExpressionSyntax:new(1, CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, module))
                        local invocation = CSharpLuaLuaAst.LuaInvocationExpressionSyntax:new(2, loadIdentifier, argument)
                        functionExpression:AddStatement1(invocation)
                    end
                    functionExpression:AddStatement(CSharpLuaLuaAst.LuaBlankLinesStatement.One)

                    local table = CSharpLuaLuaAst.LuaTableInitializerExpression()
                    for _, type in System.each(types) do
                        local typeName = this.XmlMetaProvider:GetTypeShortName(type, nil)
                        table.Items:Add1(CSharpLuaLuaAst.LuaSingleTableItemSyntax(CSharpLuaLuaAst.LuaStringLiteralExpressionSyntax:new(1, typeName)))
                    end
                    functionExpression:AddStatement1(CSharpLuaLuaAst.LuaInvocationExpressionSyntax:new(2, CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, kInit), table))

                    local luaCompilationUnit = CSharpLuaLuaAst.LuaCompilationUnitSyntax()
                    luaCompilationUnit.Statements:Add1(CSharpLuaLuaAst.LuaReturnStatementSyntax(functionExpression))

                    local outFile = SystemIO.Path.Combine(outFolder, kManifestFile)
                    Write(this, luaCompilationUnit, outFile)
                end
            end
        end
        AddTypeSymbol = function (this, typeSymbol) 
            this.types_:Add(typeSymbol)
            CheckExtends(this, typeSymbol)
        end
        CheckExtends = function (this, typeSymbol) 
            if typeSymbol:getSpecialType() ~= 1 --[[SpecialType.System_Object]] then
                if typeSymbol:getBaseType() ~= nil then
                    local super = typeSymbol:getBaseType()
                    TryAddExtend(this, super, typeSymbol)
                end
            end

            for _, super in System.each(typeSymbol:getAllInterfaces()) do
                TryAddExtend(this, super, typeSymbol)
            end
        end
        TryAddExtend = function (this, super, children) 
            if CSharpLua.Utility.IsFromCode(super) then
                if super:getIsGenericType() then
                    super = super:getOriginalDefinition()
                end
                local set = CSharpLua.Utility.GetOrDefault1(this.extends_, super, nil, MicrosoftCodeAnalysis.INamedTypeSymbol, System.HashSet(MicrosoftCodeAnalysis.INamedTypeSymbol))
                if set == nil then
                    set = System.HashSet(MicrosoftCodeAnalysis.INamedTypeSymbol)()
                    this.extends_:Add(super, set)
                end
                set:Add(children)
            end
        end
        GetMemberMethodName = function (this, symbol) 
            symbol = CSharpLua.Utility.CheckOriginalDefinition(symbol)
            local name = CSharpLua.Utility.GetOrDefault1(this.memberNames_, symbol, nil, MicrosoftCodeAnalysis.ISymbol, CSharpLuaLuaAst.LuaSymbolNameSyntax)
            if name == nil then
                local identifierName = InternalGetMemberMethodName(this, symbol)
                local symbolName = CSharpLuaLuaAst.LuaSymbolNameSyntax(identifierName)
                this.memberNames_:Add(symbol, symbolName)
                name = symbolName
            end
            return name
        end
        InternalGetMemberMethodName = function (this, symbol) 
            local name = this.XmlMetaProvider:GetMethodMapName(symbol)
            if name ~= nil then
                return CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, name)
            end

            if not CSharpLua.Utility.IsFromCode(symbol) then
                return CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, symbol:getName())
            end

            if symbol:getIsExtensionMethod() then
                return GetExtensionMethodName(this, symbol)
            end

            if symbol:getIsStatic() then
                if symbol:getContainingType():getIsStatic() then
                    return GetStaticClassMethodName(this, symbol)
                end
            end

            if symbol:getContainingType():getTypeKind() == 7 --[[TypeKind.Interface]] then
                return CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, symbol:getName())
            end

            while symbol:getOverriddenMethod() ~= nil do
                symbol = symbol:getOverriddenMethod()
            end

            local sameNameMembers = GetSameNameMembers(this, symbol)
            local symbolExpression = nil
            local index = 0
            for _, member in System.each(sameNameMembers) do
                if member:Equals(symbol) then
                    symbolExpression = CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, GetSymbolName(this, symbol))
                else
                    if not this.memberNames_:ContainsKey(member) then
                        local identifierName = CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, GetSymbolName(this, member))
                        this.memberNames_:Add(member, CSharpLuaLuaAst.LuaSymbolNameSyntax(identifierName))
                    end
                end
                if index > 0 then
                    if CSharpLua.Utility.IsFromCode(member:getContainingType()) then
                        local refactorSymbol = member
                        refactorSymbol = CSharpLua.Utility.CheckOriginalDefinition1(refactorSymbol)
                        this.refactorNames_:Add(refactorSymbol)
                    end
                end
                index = index + 1
            end

            if symbolExpression == nil then
                System.throw(System.InvalidOperationException())
            end
            return symbolExpression
        end
        GetSymbolName = function (this, symbol) 
            if symbol:getKind() == 9 --[[SymbolKind.Method]] then
                local method = System.cast(MicrosoftCodeAnalysis.IMethodSymbol, symbol)
                local name = this.XmlMetaProvider:GetMethodMapName(method)
                if name ~= nil then
                    return name
                end

                if not method:getExplicitInterfaceImplementations():getIsEmpty() then
                    return method:getExplicitInterfaceImplementations():get(0):getName()
                end
            end
            return symbol:getName()
        end
        GetExtensionMethodName = function (this, symbol) 
            assert(symbol:getIsExtensionMethod())
            return GetStaticClassMethodName(this, symbol)
        end
        GetStaticClassMethodName = function (this, symbol) 
            assert(symbol:getContainingType():getIsStatic())
            local sameNameMembers = symbol:getContainingType():GetMembers(symbol:getName())
            local symbolExpression = nil

            local index = 0
            for _, member in System.each(sameNameMembers) do
                local identifierName = GetMethodNameFromIndex(this, symbol, index)
                if member:Equals(symbol) then
                    symbolExpression = identifierName
                else
                    if not this.memberNames_:ContainsKey(member) then
                        this.memberNames_:Add(member, CSharpLuaLuaAst.LuaSymbolNameSyntax(identifierName))
                    end
                end
                index = index + 1
            end

            if symbolExpression == nil then
                System.throw(System.InvalidOperationException())
            end
            return symbolExpression
        end
        GetMethodNameFromIndex = function (this, symbol, index) 
            assert(index ~= - 1)
            if index == 0 then
                return CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, symbol:getName())
            else
                while true do
                    local newName = (symbol:getName() or "") .. index
                    if symbol:getContainingType():GetMembers(newName):getIsEmpty() then
                        if TryAddNewUsedName(this, symbol:getContainingType(), newName) then
                            return CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, newName)
                        end
                    end
                    index = index + 1
                end
            end
        end
        TryAddNewUsedName = function (this, type, newName) 
            local set = CSharpLua.Utility.GetOrDefault1(this.typeNameUseds_, type, nil, MicrosoftCodeAnalysis.INamedTypeSymbol, System.HashSet(System.String))
            if set == nil then
                set = System.HashSet(System.String)()
                this.typeNameUseds_:Add(type, set)
            end
            return set:Add(newName)
        end
        GetSameNameMembers = function (this, symbol) 
            local members = System.List(MicrosoftCodeAnalysis.ISymbol)()
            local name = GetSymbolName(this, symbol)
            FillSameNameMembers(this, symbol:getContainingType(), name, members)
            members:Sort(System.bind(this, MemberSymbolComparison))
            return members
        end
        MethodSymbolToString = function (this, symbol) 
            local sb = System.StringBuilder()
            sb:Append(symbol:getName())
            sb:Append(40 --[['(']])
            local isFirst = true
            for _, p in System.each(symbol:getParameters()) do
                if isFirst then
                    isFirst = false
                else
                    sb:Append(",")
                end
                sb:Append(p:getType():ToString())
            end
            sb:Append(41 --[[')']])
            return sb:ToString()
        end
        MemberSymbolToString = function (this, symbol) 
            if symbol:getKind() == 9 --[[SymbolKind.Method]] then
                return MethodSymbolToString(this, System.cast(MicrosoftCodeAnalysis.IMethodSymbol, symbol))
            else
                return symbol:getName()
            end
        end
        GetSymbolWright = function (this, symbol) 
            if symbol:getKind() == 9 --[[SymbolKind.Method]] then
                local methodSymbol = System.cast(MicrosoftCodeAnalysis.IMethodSymbol, symbol)
                return methodSymbol:getParameters():getLength()
            else
                return 0
            end
        end
        MemberSymbolCommonComparison = function (this, a, b) 
            local weightOfA = GetSymbolWright(this, a)
            local weightOfB = GetSymbolWright(this, b)
            if weightOfA ~= weightOfB then
                return weightOfA:CompareTo(weightOfB)
            else
                local nameOfA = MemberSymbolToString(this, a)
                local nameOfB = MemberSymbolToString(this, b)
                return nameOfA:CompareTo(nameOfB)
            end
        end
        MemberSymbolBoolComparison = function (this, a, b, boolFunc, v) 
            local boolOfA = boolFunc(a)
            local boolOfB = boolFunc(b)

            if boolOfA then
                if boolOfB then
                    v = MemberSymbolCommonComparison(this, a, b)
                else
                    v = - 1
                end
                return true, v
            end

            if b:getIsAbstract() then
                v = 1
                return true, v
            end

            v = 0
            return false, v
        end
        MemberSymbolComparison = function (this, a, b) 
            local isFromCodeOfA = CSharpLua.Utility.IsFromCode(a:getContainingType())
            local isFromCodeOfB = CSharpLua.Utility.IsFromCode(b:getContainingType())

            if not isFromCodeOfA then
                if not isFromCodeOfB then
                    return 0
                else
                    return - 1
                end
            end

            if not isFromCodeOfB then
                return 1
            end

            local countOfA = Linq.Count(CSharpLua.Utility.InterfaceImplementations(a, MicrosoftCodeAnalysis.ISymbol))
            local countOfB = Linq.Count(CSharpLua.Utility.InterfaceImplementations(b, MicrosoftCodeAnalysis.ISymbol))
            if countOfA > 0 or countOfB > 0 then
                if countOfA ~= countOfB then
                    return countOfA > countOfB and - 1 or 1
                else
                    return MemberSymbolCommonComparison(this, a, b)
                end
            end

            local v
            local default
            default, v = MemberSymbolBoolComparison(this, a, b, function (i) 
                return i:getIsAbstract()
            end, v)
            if default then
                return v
            end
            local extern
            extern, v = MemberSymbolBoolComparison(this, a, b, function (i) 
                return i:getIsVirtual()
            end, v)
            if extern then
                return v
            end
            local ref
            ref, v = MemberSymbolBoolComparison(this, a, b, function (i) 
                return i:getIsOverride()
            end, v)
            if ref then
                return v
            end

            if a:getContainingType():Equals(b:getContainingType()) then
                local name = a:getName()
                local type = a:getContainingType()
                local members = type:GetMembers(name)
                local indexOfA = members:IndexOf(a)
                assert(indexOfA ~= - 1)
                local indexOfB = members:IndexOf(b)
                assert(indexOfB ~= - 1)
                assert(indexOfA ~= indexOfB)
                return indexOfA:CompareTo(indexOfB)
            else
                local isSubclassOf = CSharpLua.Utility.IsSubclassOf(a:getContainingType(), b:getContainingType())
                return isSubclassOf and 1 or - 1
            end
        end
        FillSameNameMembers = function (this, typeSymbol, name, outList) 
            if typeSymbol:getBaseType() ~= nil then
                FillSameNameMembers(this, typeSymbol:getBaseType(), name, outList)
            end

            local isFromCode = CSharpLua.Utility.IsFromCode(typeSymbol)
            local members = typeSymbol:GetMembers()
            for _, member in System.each(members) do
                local continue
                repeat
                    if not isFromCode then
                        if member:getDeclaredAccessibility() == 1 --[[Accessibility.Private]] or member:getDeclaredAccessibility() == 4 --[[Accessibility.Internal]] then
                            continue = true
                            break
                        end
                    end

                    if member:getIsOverride() then
                        continue = true
                        break
                    end

                    local memberName = GetSymbolName(this, member)
                    if memberName == name then
                        outList:Add(member)
                    end
                    continue = true
                until 1
                if not continue then
                    break
                end
            end
        end
        CheckRefactorNames = function (this) 
            local alreadyRefactorSymbols = System.HashSet(MicrosoftCodeAnalysis.ISymbol)()
            for _, symbol in System.each(this.refactorNames_) do
                local hasImplementation = false
                for _, implementation in System.each(CSharpLua.Utility.InterfaceImplementations(symbol, MicrosoftCodeAnalysis.ISymbol)) do
                    RefactorInterfaceSymbol(this, implementation, alreadyRefactorSymbols)
                    hasImplementation = true
                end

                if not hasImplementation then
                    RefactorCurTypeSymbol(this, symbol, alreadyRefactorSymbols)
                end
            end
        end
        RefactorCurTypeSymbol = function (this, symbol, alreadyRefactorSymbols) 
            local typeSymbol = symbol:getContainingType()
            local childrens = CSharpLua.Utility.GetOrDefault1(this.extends_, typeSymbol, nil, MicrosoftCodeAnalysis.INamedTypeSymbol, System.HashSet(MicrosoftCodeAnalysis.INamedTypeSymbol))
            local newName = GetRefactorName(this, typeSymbol, childrens, symbol:getName())
            RefactorName(this, symbol, newName, alreadyRefactorSymbols)
        end
        RefactorInterfaceSymbol = function (this, symbol, alreadyRefactorSymbols) 
            if CSharpLua.Utility.IsFromCode(symbol) then
                local typeSymbol = symbol:getContainingType()
                assert(typeSymbol:getTypeKind() == 7 --[[TypeKind.Interface]])
                local childrens = this.extends_:get(typeSymbol)
                local newName = GetRefactorName(this, nil, childrens, symbol:getName())
                for _, children in System.each(childrens) do
                    local childrenSymbol = children:FindImplementationForInterfaceMember(symbol)
                    assert(childrenSymbol ~= nil)
                    RefactorName(this, childrenSymbol, newName, alreadyRefactorSymbols)
                end
            end
        end
        RefactorName = function (this, symbol, newName, alreadyRefactorSymbols) 
            if not alreadyRefactorSymbols:Contains(symbol) then
                if CSharpLua.Utility.IsOverridable(symbol) then
                    RefactorChildrensOverridden(this, symbol, symbol:getContainingType(), newName, alreadyRefactorSymbols)
                end
                UpdateName(this, symbol, newName, alreadyRefactorSymbols)
            end
        end
        RefactorChildrensOverridden = function (this, originalSymbol, curType, newName, alreadyRefactorSymbols) 
            local childrens = CSharpLua.Utility.GetOrDefault1(this.extends_, curType, nil, MicrosoftCodeAnalysis.INamedTypeSymbol, System.HashSet(MicrosoftCodeAnalysis.INamedTypeSymbol))
            if childrens ~= nil then
                for _, children in System.each(childrens) do
                    local curSymbol = SystemLinq.ImmutableArrayExtensions.FirstOrDefault(children:GetMembers(originalSymbol:getName()), function (i) 
                        return CSharpLua.Utility.IsOverridden(i, originalSymbol)
                    end, MicrosoftCodeAnalysis.ISymbol)
                    if curSymbol ~= nil then
                        UpdateName(this, curSymbol, newName, alreadyRefactorSymbols)
                    end
                    RefactorChildrensOverridden(this, originalSymbol, children, newName, alreadyRefactorSymbols)
                end
            end
        end
        UpdateName = function (this, symbol, newName, alreadyRefactorSymbols) 
            this.memberNames_:get(symbol):Update(newName)
            TryAddNewUsedName(this, symbol:getContainingType(), newName)
            alreadyRefactorSymbols:Add(symbol)
        end
        GetRefactorName = function (this, typeSymbol, childrens, originalName) 
            local index = 1
            while true do
                local newName = (originalName or "") .. index
                local isEnable = true
                if typeSymbol ~= nil then
                    isEnable = CheckNewNameEnable(this, typeSymbol, newName)
                end

                if isEnable then
                    if childrens ~= nil then
                        isEnable = Linq.All(childrens, function (i) 
                            return CheckNewNameEnable(this, i, newName)
                        end)
                    end
                end

                if isEnable then
                    return newName
                end
                index = index + 1
            end
        end
        IsTypeNameUsed = function (this, typeSymbol, newName) 
            local set = CSharpLua.Utility.GetOrDefault1(this.typeNameUseds_, typeSymbol, nil, MicrosoftCodeAnalysis.INamedTypeSymbol, System.HashSet(System.String))
            return set ~= nil and set:Contains(newName)
        end
        CheckNewNameEnable = function (this, typeSymbol, newName) 
            if typeSymbol:GetMembers(newName):getIsEmpty() then
                if IsTypeNameUsed(this, typeSymbol, newName) then
                    return false
                end
            end

            local childrens = CSharpLua.Utility.GetOrDefault1(this.extends_, typeSymbol, nil, MicrosoftCodeAnalysis.INamedTypeSymbol, System.HashSet(MicrosoftCodeAnalysis.INamedTypeSymbol))
            if childrens ~= nil then
                for _, children in System.each(childrens) do
                    if not CheckNewNameEnable(this, children, newName) then
                        return false
                    end
                end
            end

            return true
        end
        __staticCtor__ = function (this) 
            Encoding = SystemText.UTF8Encoding(false)
        end
        __init__ = function (this) 
            this.exportEnums_ = System.HashSet(System.String)()
            this.enumDeclarations_ = System.List(CSharpLuaLuaAst.LuaEnumDeclarationSyntax)()
            this.partialTypes_ = System.Dictionary(MicrosoftCodeAnalysis.INamedTypeSymbol, System.List(CSharpLua.PartialTypeDeclaration))()
            this.memberNames_ = System.Dictionary(MicrosoftCodeAnalysis.ISymbol, CSharpLuaLuaAst.LuaSymbolNameSyntax)()
            this.typeNameUseds_ = System.Dictionary(MicrosoftCodeAnalysis.INamedTypeSymbol, System.HashSet(System.String))()
            this.refactorNames_ = System.HashSet(MicrosoftCodeAnalysis.ISymbol)()
            this.extends_ = System.Dictionary(MicrosoftCodeAnalysis.INamedTypeSymbol, System.HashSet(MicrosoftCodeAnalysis.INamedTypeSymbol))()
            this.types_ = System.List(MicrosoftCodeAnalysis.INamedTypeSymbol)()
        end
        __ctor__ = function (this, syntaxTrees, references, metas, setting, attributes) 
            __init__(this)
            local compilation = MicrosoftCodeAnalysisCSharp.CSharpCompilation.Create("_", syntaxTrees, references, MicrosoftCodeAnalysisCSharp.CSharpCompilationOptions(2 --[[OutputKind.DynamicallyLinkedLibrary]], false, nil, nil, nil, nil, 0, false, false, nil, nil, nil, nil, 0, 0, 4, nil, true, false, nil, nil, nil, nil, nil, false))
            System.using(SystemIO.MemoryStream(), function (ms) 
                local result = compilation:Emit(ms, nil, nil, nil, nil, nil, nil, nil)
                if not result:getSuccess() then
                    local errors = SystemLinq.ImmutableArrayExtensions.Where(result:getDiagnostics(), function (i) 
                        return i:getSeverity() == 3 --[[DiagnosticSeverity.Error]]
                    end, MicrosoftCodeAnalysis.Diagnostic)
                    local message = System.String.Join("\n", errors, MicrosoftCodeAnalysis.Diagnostic)
                    System.throw(CSharpLua.CompilationErrorException(message))
                end
            end)
            this.compilation_ = compilation
            this.XmlMetaProvider = CSharpLua.XmlMetaProvider(metas)
            this.Setting = setting
            if attributes ~= nil then
                this.exportAttributes_ = System.HashSet(System.String)(attributes)
            end
        end
        return {
            Generate = Generate, 
            IsEnumExport = IsEnumExport, 
            AddExportEnum = AddExportEnum, 
            AddEnumDeclaration = AddEnumDeclaration, 
            IsExportAttribute = IsExportAttribute, 
            AddPartialTypeDeclaration = AddPartialTypeDeclaration, 
            GetSemanticModel = GetSemanticModel, 
            IsBaseType = IsBaseType, 
            GetMethodName = GetMethodName, 
            AddTypeSymbol = AddTypeSymbol, 
            GetMemberMethodName = GetMemberMethodName, 
            __staticCtor__ = __staticCtor__, 
            __ctor__ = __ctor__
        }
    end)
end)
