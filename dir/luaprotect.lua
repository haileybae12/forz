local _legacyluaprotector = { cache = {} }
do
	do
		local function __modImpl()
			local config = {}
			config.settings = {
				output_suffix = "_zukaencrypt.lua",
				watermark_enabled = false,
				final_print = true,
				VirtualMachine = {
					enabled = true,
				},
				antitamper = {
					enabled = true,
				},
				control_flow = {
					enabled = true,
					max_fake_blocks = 6,
				},
				StringToExpressions = {
					enabled = false,
					min_number_length = 100,
					max_number_length = 999,
				},
				string_encoding = {
					enabled = false,
				},
				WrapInFunction = {
					enabled = true,
				},
				variable_renaming = {
					enabled = true,
					min_name_length = 8,
					max_name_length = 12,
				},
				garbage_code = {
					enabled = true,
					garbage_blocks = 20,
				},
				opaque_predicates = {
					enabled = true,
				},
				function_inlining = {
					enabled = false,
				},
				dynamic_code = {
					enabled = false,
				},
				bytecode_encoding = {
					enabled = false,
				},
				compressor = {
					enabled = true,
				},
			}
			function config.get(key)
				local keys = {}
				for k in key:gmatch("[^.]+") do
					table.insert(keys, k)
				end
				local value = config
				for _, k in ipairs(keys) do
					value = value[k]
					if value == nil then
						return nil
					end
				end
				return value
			end
			function config.set(key, new_value)
				local keys = {}
				for k in key:gmatch("[^.]+") do
					table.insert(keys, k)
				end
				local value = config
				for i = 1, #keys - 1 do
					value = value[keys[i]]
					if value == nil then
						return false
					end
				end
				local last_key = keys[#keys]
				if value[last_key] ~= nil then
					value[last_key] = new_value
					return true
				else
					return false
				end
			end
			return config
		end
		function _legacyluaprotector.a()
			local v = _legacyluaprotector.cache.a
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.a = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local StringEncoder = {}
			local function generateRandomName(len)
				len = len or math.random(8, 12)
				local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
				local name = ""
				for _ = 1, len do
					local index = math.random(1, #charset)
					name = name .. charset:sub(index, index)
				end
				return name
			end
			local function isValidChar(byte)
				return (byte >= 48 and byte <= 57) or (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122)
			end
			local function caesarCipher(data, offset)
				local result = {}
				local i = 1
				while i <= #data do
					local byte = data:byte(i)
					if byte == 92 and i < #data then
						local next_char = data:sub(i + 1, i + 1)
						if next_char == "2" and data:sub(i + 2, i + 2) == "7" then
							table.insert(result, string.char(byte))
							table.insert(result, next_char)
							table.insert(result, data:sub(i + 2, i + 2))
							i = i + 2
						else
							table.insert(result, string.char(byte))
							table.insert(result, next_char)
							i = i + 1
						end
					elseif isValidChar(byte) then
						local new_byte
						if byte >= 48 and byte <= 57 then
							new_byte = ((byte - 48 + offset) % 10) + 48
						elseif byte >= 65 and byte <= 90 then
							new_byte = ((byte - 65 + offset) % 26) + 65
						elseif byte >= 97 and byte <= 122 then
							new_byte = ((byte - 97 + offset) % 26) + 97
						end
						table.insert(result, string.char(new_byte))
					else
						table.insert(result, string.char(byte))
					end
					i = i + 1
				end
				return table.concat(result)
			end
			function StringEncoder.process(code)
				local random_decrypt_name = generateRandomName()
				local random_isvalidchar_name = generateRandomName()
				local random_result_name = generateRandomName()
				local random_code_name = generateRandomName()
				local random_offset_name = generateRandomName()
				local random_byte_name = generateRandomName()
				local random_new_byte_name = generateRandomName()
				local decode_function = [[
            local function ]] .. random_isvalidchar_name .. [[(]] .. random_byte_name .. [[)
                return (]] .. random_byte_name .. [[ >= 48 and ]] .. random_byte_name .. [[ <= 57) or (]] .. random_byte_name .. [[ >= 65 and ]] .. random_byte_name .. [[ <= 90) or (]] .. random_byte_name .. [[ >= 97 and ]] .. random_byte_name .. [[ <= 122)
            end
            local function ]] .. random_decrypt_name .. [[(]] .. random_code_name .. [[, ]] .. random_offset_name .. [[)
                local ]] .. random_result_name .. [[ = {}
                for i = 1, #]] .. random_code_name .. [[ do
                    local ]] .. random_byte_name .. [[ = ]] .. random_code_name .. [[:byte(i)
                    if ]] .. random_isvalidchar_name .. [[(]] .. random_byte_name .. [[) then
                        local ]] .. random_new_byte_name .. [[
                        if ]] .. random_byte_name .. [[ >= 48 and ]] .. random_byte_name .. [[ <= 57 then
                            ]] .. random_new_byte_name .. [[ = ((]] .. random_byte_name .. [[ - 48 - ]] .. random_offset_name .. [[ + 10) % 10) + 48
                        elseif ]] .. random_byte_name .. [[ >= 65 and ]] .. random_byte_name .. [[ <= 90 then
                            ]] .. random_new_byte_name .. [[ = ((]] .. random_byte_name .. [[ - 65 - ]] .. random_offset_name .. [[ + 26) % 26) + 65
                        elseif ]] .. random_byte_name .. [[ >= 97 and ]] .. random_byte_name .. [[ <= 122 then
                            ]] .. random_new_byte_name .. [[ = ((]] .. random_byte_name .. [[ - 97 - ]] .. random_offset_name .. [[ + 26) % 26) + 97
                        end
                        table.insert(]] .. random_result_name .. [[, string.char(]] .. random_new_byte_name .. [[))
                    else
                        table.insert(]] .. random_result_name .. [[, string.char(]] .. random_byte_name .. [[))
                    end
                end
                return table.concat(]] .. random_result_name .. [[)
            end
            local function ]] .. random_isvalidchar_name .. [[(]] .. random_byte_name .. [[)
                return (]] .. random_byte_name .. [[ >= 48 and ]] .. random_byte_name .. [[ <= 57) or (]] .. random_byte_name .. [[ >= 65 and ]] .. random_byte_name .. [[ <= 90) or (]] .. random_byte_name .. [[ >= 97 and ]] .. random_byte_name .. [[ <= 122)
            end
            ]]
				code = code:gsub('\\"', "!@!"):gsub("\\'", "@!@")
				code = code:gsub("(['\"])(.-)%1", function(quote, str)
					if type(str) == "string" then
						str = str:gsub("!@!", '\\"'):gsub("@!@", "\\'")
						local offset = math.random(1, 9)
						if str:match("%a") then
							offset = math.random(1, 25)
						end
						local encoded_str = caesarCipher(str, offset)
						return string.format(
							"%s(" .. quote .. "%s" .. quote .. ", %d)",
							random_decrypt_name,
							encoded_str,
							offset
						)
					else
						return str
					end
				end)
				return decode_function .. "\n" .. code
			end
			return StringEncoder
		end
		function _legacyluaprotector.b()
			local v = _legacyluaprotector.cache.b
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.b = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local VariableRenamer = {}
			local varenc_names = {}
			local lua_functions = {
				"assert",
				"collectgarbage",
				"dofile",
				"loadfile",
				"loadstring",
				"ipairs",
				"pairs",
				"tonumber",
				"tostring",
				"type",
				"print",
				"_G",
				"_VERSION",
				"write",
				"sort",
				"math.abs",
				"math.acos",
				"math.asin",
				"math.atan",
				"math.atan2",
				"math.ceil",
				"math.cos",
				"math.cosh",
				"math.deg",
				"math.exp",
				"math.floor",
				"math.fmod",
				"math.frexp",
				"math.ldexp",
				"math.log",
				"math.log10",
				"math.max",
				"math.min",
				"math.modf",
				"math.pi",
				"math.pow",
				"math.rad",
				"math.random",
				"math.randomseed",
				"math.sin",
				"math.sinh",
				"math.sqrt",
				"math.tan",
				"math.tanh",
				"string.byte",
				"string.char",
				"string.dump",
				"string.find",
				"string.format",
				"string.gmatch",
				"string.gsub",
				"string.len",
				"string.lower",
				"string.match",
				"string.rep",
				"string.reverse",
				"string.sub",
				"string.upper",
				"table.concat",
				"table.insert",
				"table.remove",
				"table.sort",
				"table.pack",
				"table.unpack",
				"game:GetService",
			}
			local reserved_words = {
				["if"] = true,
				["then"] = true,
				["else"] = true,
				["elseif"] = true,
				["end"] = true,
				["for"] = true,
				["while"] = true,
				["do"] = true,
				["repeat"] = true,
				["until"] = true,
				["function"] = true,
				["local"] = true,
				["return"] = true,
				["break"] = true,
				["continue"] = true,
				["and"] = true,
				["or"] = true,
				["not"] = true,
				["in"] = true,
				["nil"] = true,
				["true"] = true,
				["false"] = true,
			}
			local DEFAULT_MIN_NAME_LENGTH, DEFAULT_MAX_NAME_LENGTH = 8, 12
			local name_min, name_max = DEFAULT_MIN_NAME_LENGTH, DEFAULT_MAX_NAME_LENGTH
			local function generateRandomName()
				local len = math.random(name_min, name_max)
				local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
				local name = ""
				for _ = 1, len do
					local index = math.random(1, #charset)
					name = name .. charset:sub(index, index)
				end
				return name
			end
			local function replaceUnquoted(input, target, replacement)
				local placeholder = "!!!"
				local protected_input = input:gsub("([\"'])(.-)%1", function(q, content)
					content = content:gsub('\\"', "!@!"):gsub("\\'", "@!@")
					content = content:gsub(target, placeholder)
					content = content:gsub("!@!", '\\"'):gsub("@!@", "\\'")
					return q .. content .. q
				end)
				local result = protected_input:gsub("(%f[%w_])" .. target .. "(%f[^%w_])", function(before, after)
					return before .. replacement .. after
				end)
				result = result:gsub(placeholder, target)
				return result
			end
			local function obfuscateLocalVariables(code)
				local local_var_pattern = "local%s+([%w_,%s]+)%s*=%s*"
				local var_map = {}
				local obfuscated_code = code
				for local_vars in code:gmatch(local_var_pattern) do
					for var in local_vars:gmatch("[%w_]+") do
						if
							#var > 1
							and not varenc_names[var]
							and not reserved_words[var]
							and not var:match("^__")
							and not var:match("^_ZukaTech")
						then
							var_map[var] = generateRandomName()
						end
					end
				end
				for original_var, obfuscated_var in pairs(var_map) do
					obfuscated_code = replaceUnquoted(obfuscated_code, original_var, obfuscated_var)
				end
				return obfuscated_code, var_map
			end
			local function obfuscateFunctions(code)
				local func_map = {}
				local arg_map = {}
				local obfuscated_code = code
				for func_name, args in code:gmatch("function%s+([%w_]+)%s*%(([%w_,%s]*)%)") do
					if
						not reserved_words[func_name]
						and not func_map[func_name]
						and not func_name:match("^__")
						and not func_name:match("^_ZukaTech")
					then
						func_map[func_name] = generateRandomName()
					end
					for arg in args:gmatch("[%w_]+") do
						if not reserved_words[arg] and not arg_map[arg] then
							arg_map[arg] = generateRandomName()
						end
					end
				end
				obfuscated_code = obfuscated_code:gsub("function%s+([%w_]+)", function(func_name)
					return "function " .. (func_map[func_name] or func_name)
				end)
				for original_func, obfuscated_func in pairs(func_map) do
					obfuscated_code = obfuscated_code:gsub(original_func .. "%(", obfuscated_func .. "(")
				end
				for original_arg, obfuscated_arg in pairs(arg_map) do
					obfuscated_code = replaceUnquoted(obfuscated_code, original_arg, obfuscated_arg)
				end
				return obfuscated_code
			end
			function VariableRenamer.process(code, options)
				options = options or {}
				name_min = options.min_length or DEFAULT_MIN_NAME_LENGTH
				name_max = options.max_length or DEFAULT_MAX_NAME_LENGTH
				local renamed_vars = {}
				local assignment_lines = {}
				local obfuscated_code, var_map = obfuscateLocalVariables(code)
				obfuscated_code = obfuscateFunctions(obfuscated_code)
				for _, function_name in ipairs(lua_functions) do
					if string.find(code, function_name, 1, true) then
						if not varenc_names[function_name] then
							local new_name = generateRandomName()
							varenc_names[function_name] = new_name
							table.insert(renamed_vars, new_name)
							table.insert(assignment_lines, new_name .. " = " .. function_name .. ";")
						end
						obfuscated_code =
							obfuscated_code:gsub(function_name .. "%(", varenc_names[function_name] .. "(")
					end
				end
				local local_declaration = #renamed_vars > 0 and "local " .. table.concat(renamed_vars, ", ") or ""
				local assignments = #assignment_lines > 0 and "\n" .. table.concat(assignment_lines, " ") or ""
				local result = local_declaration .. assignments .. "\n" .. obfuscated_code
				name_min, name_max = DEFAULT_MIN_NAME_LENGTH, DEFAULT_MAX_NAME_LENGTH
				return result
			end
			return VariableRenamer
		end
		function _legacyluaprotector.c()
			local v = _legacyluaprotector.cache.c
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.c = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local ControlFlowObfuscator = {}
			math.randomseed(os.time())
			local function controlFlow(code, n, a, depth, depth_values)
				n = n or math.floor(math.random() * 7000)
				a = n
				depth = depth or 0
				depth_values = depth_values or {}
				depth_values[#depth_values + 1] = { n, a }
				local operators = { ">", "<", "==" }
				local while_operator = operators[math.random(1, 3)]
				local step = math.floor(math.random() * 990) + 10
				local max_iterations = 3
				if while_operator == "<" then
					a = n + (step * max_iterations)
				elseif while_operator == ">" then
					a = n - (step * max_iterations)
					if a < 0 then
						a = 0
					end
					step = -step
				elseif while_operator == "==" then
					a = n
					if math.random() > 0.5 then
						step = -step
					end
				end
				local threshold = (n + step)
				local src = depth == 0
						and string.format(
							"local thing = %d;\nlocal thing2 = %d;\nlocal counter = 0;\nlocal threshold = %d;\n",
							n,
							a,
							threshold
						)
					or ""
				src = src
					.. string.format("while thing %s thing2 and counter < %d do\n", while_operator, max_iterations)
				src = src .. string.format("    thing = thing + %d;\n", step)
				src = src .. "    counter = counter + 1;\n"
				src = src .. "    if thing < threshold then\n"
				local function generateSpoof()
					local spoof_lines = {
						string.format("local temp = %d; temp = temp * 2;", math.floor(math.random() * 100)),
						"local str = 'dummy'; str = str .. str;",
						string.format(
							"local x = %d; x = x - %d;",
							math.floor(math.random() * 50),
							math.floor(math.random() * 10)
						),
						"local tbl = {1, 2, 3}; table.sort(tbl, function(a, b) return a > b end);",
					}
					return spoof_lines[math.random(1, #spoof_lines)]
				end
				if depth == (#code - 1) then
					src = src .. string.format("        %s\n", generateSpoof())
					src = src .. string.format("    else\n        %s\n        break\n", code[1])
					table.remove(code, 1)
				else
					local sub_src, new_n, new_a = controlFlow(code, n, a, depth + 1, depth_values)
					src = src .. string.format("        %s\n", generateSpoof())
					src = src .. string.format("    else\n        %s\n        break\n", sub_src)
					n = new_n
					a = new_a
				end
				src = src .. "    end\nend\n"
				if math.random() > 0.5 then
					src = src .. string.format("local dummy = 1; dummy = dummy + %d;\n", math.floor(math.random() * 10))
				end
				return depth == 0 and src or { src, n, a }
			end
			function ControlFlowObfuscator.process(code, max_fake_blocks)
				if type(code) ~= "string" then
					error("Input code must be a string")
				end
				local code_table = { code }
				return controlFlow(code_table)
			end
			return ControlFlowObfuscator
		end
		function _legacyluaprotector.d()
			local v = _legacyluaprotector.cache.d
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.d = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local GarbageCodeInserter = {}
			local LOWERCASE_A, LOWERCASE_Z = 97, 122
			local MAX_RANDOM_NUMBER = 100
			local MAX_LOOP_COUNT = 10
			local VARIABLE_NAME_LENGTH = 6
			local function generateRandomVariableName()
				local name = {}
				for i = 1, VARIABLE_NAME_LENGTH do
					table.insert(name, string.char(math.random(LOWERCASE_A, LOWERCASE_Z)))
				end
				return table.concat(name)
			end
			local function generateRandomNumber(max)
				return math.random(1, max or MAX_RANDOM_NUMBER)
			end
			local code_types = {
				variable = function()
					return string.format("local %s = %d", generateRandomVariableName(), generateRandomNumber())
				end,
				while_loop = function()
					return string.format(
						"while %s do local _ = %d break end",
						tostring(math.random() > 0.5),
						generateRandomNumber(100)
					)
				end,
				for_loop = function()
					return string.format(
						"for %s = 1, %d do local _ = %d end",
						generateRandomVariableName(),
						generateRandomNumber(MAX_LOOP_COUNT),
						generateRandomNumber()
					)
				end,
				if_statement = function()
					return string.format(
						"if %s then local _ = %d end",
						tostring(math.random() > 0.5),
						generateRandomNumber()
					)
				end,
				function_def = function()
					return string.format(
						"local function %s(%s) local _ = %d end",
						generateRandomVariableName(),
						generateRandomVariableName(),
						generateRandomNumber()
					)
				end,
			}
			local code_type_keys = {}
			for k in pairs(code_types) do
				table.insert(code_type_keys, k)
			end
			local function generateRandomCode()
				return code_types[code_type_keys[math.random(#code_type_keys)]]()
			end
			local function generateGarbage(blocks, sep)
				sep = sep or "\n"
				local garbage_code = {}
				for i = 1, blocks do
					local code = generateRandomCode()
					if not code:match("while true") and not code:match("for %w+ = %d+, %d+ do local _ = %d+ end") then
						table.insert(garbage_code, code)
					end
				end
				return table.concat(garbage_code, sep)
			end
			function GarbageCodeInserter.process(code, garbage_blocks)
				if type(code) ~= "string" or #code == 0 then
					error("Input code must be a non-empty string", 2)
				end
				if type(garbage_blocks) ~= "number" then
					error("garbage_blocks must be a number", 2)
				end
				local prefix_garbage = generateGarbage(garbage_blocks)
				local suffix_garbage = generateGarbage(garbage_blocks)
				return table.concat({ prefix_garbage, code, suffix_garbage }, "\n")
			end
			function GarbageCodeInserter.setSeed(seed)
				math.randomseed(seed)
			end
			return GarbageCodeInserter
		end
		function _legacyluaprotector.e()
			local v = _legacyluaprotector.cache.e
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.e = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local OpaquePredicateInjector = {}
			local function generatePredicates()
				local predicates = {
					function()
						local n = math.random(10, 100)
						return string.format("if (%d %% 1 == 0 and %d >= %d) then", n, n, n)
					end,
					function()
						local x = math.random(1, 10)
						return string.format("if (%d %% %d == 0) then", x, x)
					end,
					function()
						local angle = math.random(0, 360)
						return string.format("if (math.sin(%d)^2 + math.cos(%d)^2 >= 0.99999) then", angle, angle)
					end,
					function()
						local str = string.format("%x", math.random(1000, 9999))
						return string.format(
							"if (select(2, pcall(function() return tonumber('%s', 16) end)) ~= nil) then",
							str
						)
					end,
					function()
						local size = math.random(2, 5)
						return string.format("if (#{%s} == %d) then", string.rep("1,", size - 1) .. "1", size)
					end,
					function()
						local a, b = math.random(1, 10), math.random(11, 20)
						return string.format("if ((%d < %d) == not (%d >= %d)) then", a, b, a, b)
					end,
				}
				return predicates[math.random(#predicates)]()
			end
			local function isInjectSafe(statement)
				if statement:match("^%s*[%{%}]%s*$") or statement:match("^%s*$") or not statement:match(".+;") then
					return false
				end
				local unsafes = {
					"^%s*for%s+",
					"^%s*while%s+",
					"^%s*if%s+",
					"^%s*repeat%s+",
					"^%s*until%s+",
					"^%s*function%s+",
					"^%s*local%s+function",
					"^%s*do%s+",
				}
				for _, pattern in ipairs(unsafes) do
					if statement:match(pattern) then
						return false
					end
				end
				if statement:match("^%s*if%s+.+%s+then%s+.+%s+end%s*;?$") then
					return false
				end
				return true
			end
			local function injectPredicates(block)
				if block:match("%s*end%s*;?$") or block:match("^%s*return") then
					return block
				else
					local predicate = generatePredicates()
					return predicate .. block .. " end;"
				end
			end
			function OpaquePredicateInjector.process(code)
				if type(code) ~= "string" then
					error("Input must be a string")
				end
				local success, processed_code = pcall(function()
					local result = code:gsub("([ \t]*)([^\n;]*;)", function(ws, statement)
						if isInjectSafe(statement) then
							return ws .. injectPredicates(statement)
						else
							return ws .. statement
						end
					end)
					result = result:gsub("([ \t]*)(return%s+[^\n;]+;)", function(ws, return_stmt)
						return ws .. return_stmt
					end)
					return result
				end)
				if not success then
					error("Failed to process code: " .. tostring(processed_code))
				end
				return processed_code
			end
			function OpaquePredicateInjector.validateCode(code)
				local f, err = load(code)
				return f ~= nil, err
			end
			return OpaquePredicateInjector
		end
		function _legacyluaprotector.f()
			local v = _legacyluaprotector.cache.f
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.f = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local FunctionInliner = {}
			function FunctionInliner.process(code)
				if code:match("^%s*%-%-.*Obfuscated") then
					return code
				end
				local functions = {}
				local output = code
				output = output:gsub("%-%-[^\n]*", "")
				output = output:gsub("local%s+function%s+([%w_]+)%s*%(([^)]*)%)(.-)end", function(name, params, body)
					functions[name] = { params = params, body = body }
					return ""
				end)
				output = output:gsub("function%s+([%w_]+)%s*%(([^)]*)%)(.-)end", function(name, params, body)
					functions[name] = { params = params, body = body }
					return ""
				end)
				for name, func in pairs(functions) do
					output = output:gsub(name .. "%s*(%b())", function(call)
						local args = call:sub(2, -2)
						local body = func.body
						local params = {}
						for param in func.params:gmatch("[^,%s]+") do
							params[#params + 1] = param
						end
						local arguments = {}
						for arg in (args .. ","):gmatch("([^,]*),") do
							arguments[#arguments + 1] = arg:match("^%s*(.-)%s*$")
						end
						for i, param in ipairs(params) do
							local arg = arguments[i] or "nil"
							body = body:gsub("%f[%w_]" .. param .. "%f[^%w_]", arg)
						end
						if body:match("^%s*return%s+.+") then
							body = body:gsub("^%s*return%s+", "")
						end
						return "(" .. body:match("^%s*(.-)%s*$") .. ")"
					end)
				end
				output = output:gsub("end%s*$", "")
				output = output:gsub("end%s*\n", "\n")
				output = output:gsub("\n%s*\n", "\n")
				return output
			end
			return FunctionInliner
		end
		function _legacyluaprotector.g()
			local v = _legacyluaprotector.cache.g
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.g = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local DynamicCodeGenerator = {}
			function DynamicCodeGenerator.process(code)
				local function dynamicWrapper(block)
					local func, err = load("return " .. block)
					if not func then
						error("Failed to load block: " .. err)
					end
					return func()
				end
				local processed_code = {}
				local position = 1
				while position <= #code do
					local next_position = code:find("[%s%p]", position)
					if not next_position then
						next_position = #code + 1
					end
					local block = code:sub(position, next_position - 1)
					if #block > 0 then
						local success, result = pcall(dynamicWrapper, block)
						if success then
							table.insert(processed_code, tostring(result))
						else
							error("Error processing block '" .. block .. "': " .. result)
						end
					end
					if next_position <= #code then
						table.insert(processed_code, code:sub(next_position, next_position))
					end
					position = next_position + 1
				end
				return table.concat(processed_code)
			end
			return DynamicCodeGenerator
		end
		function _legacyluaprotector.h()
			local v = _legacyluaprotector.cache.h
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.h = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local BytecodeEncoder = {}
			local function encodeBytecode(bytecode, offset)
				local encoded = {}
				for i = 1, #bytecode do
					local byte = bytecode:byte(i)
					local shifted_byte = (byte + offset) % 256
					table.insert(encoded, string.format("%02X", shifted_byte))
				end
				return table.concat(encoded)
			end
			function BytecodeEncoder.process(code)
				local bytecode = string.dump(assert(load(code)))
				local offset = math.random(1, 255)
				local encoded_bytecode = encodeBytecode(bytecode, offset)
				local alpha = [[
                    local e, o, d = "%s", %d, {}
                    for i = 1, #e, 2 do
                        local b = tonumber(e:sub(i, i + 1), 16)
                        b = (b - o + 256) % 256
                        d[#d + 1] = string.char(b)
                    end
                    local f = assert(load(table.concat(d)))
                    f()
                ]]
				return string.format(alpha, encoded_bytecode, offset)
			end
			return BytecodeEncoder
		end
		function _legacyluaprotector.i()
			local v = _legacyluaprotector.cache.i
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.i = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Watermark = {}
			function Watermark.process(code)
				return "--[Obfuscation? more like masturbation.]\n" .. code
			end
			return Watermark
		end
		function _legacyluaprotector.j()
			local v = _legacyluaprotector.cache.j
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.j = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Compressor = {}
			local LUA_KEYWORDS = {
				"and",
				"break",
				"do",
				"else",
				"elseif",
				"end",
				"false",
				"for",
				"function",
				"goto",
				"if",
				"in",
				"local",
				"nil",
				"not",
				"or",
				"repeat",
				"return",
				"then",
				"true",
				"until",
				"while",
			}
			local KW_PLACEHOLDER_PRE = "@@KW_"
			local KW_PLACEHOLDER_POST = "_KW@@"
			local STR_PLACEHOLDER_PRE = "@@S_"
			local STR_PLACEHOLDER_POST = "_S@@"
			function Compressor.process(code)
				if type(code) ~= "string" then
					error("Input code must be a string.", 2)
				end
				if #code < 10 or code:match("^[%s%d%p]*$") then
					return code:match("^%s*(.-)%s*$") or ""
				end
				local strings = {}
				local string_count = 0
				local keywords_map = {}
				local function preserveStrings(c)
					c = c:gsub("%[(=*)%[(.-)%]%1%]", function(equals, str)
						string_count = string_count + 1
						local key = STR_PLACEHOLDER_PRE .. string_count .. STR_PLACEHOLDER_POST
						strings[key] = "[" .. equals .. "[" .. str .. "]" .. equals .. "]"
						return key
					end)
					c = c:gsub('"(.-)"', function(str)
						if not str:find("\\", 1, true) and str:find(STR_PLACEHOLDER_PRE, 1, true) then
							return '"' .. str .. '"'
						end
						string_count = string_count + 1
						local key = STR_PLACEHOLDER_PRE .. string_count .. STR_PLACEHOLDER_POST
						strings[key] = '"' .. str .. '"'
						return key
					end)
					c = c:gsub("('.-')", function(str)
						if not str:find("\\", 1, true) and str:find(STR_PLACEHOLDER_PRE, 1, true) then
							return "'" .. str .. "'"
						end
						string_count = string_count + 1
						local key = STR_PLACEHOLDER_PRE .. string_count .. STR_PLACEHOLDER_POST
						strings[key] = str
						return key
					end)
					return c
				end
				local function preserveKeywords(c)
					for _, keyword in ipairs(LUA_KEYWORDS) do
						local placeholder = KW_PLACEHOLDER_PRE .. keyword .. KW_PLACEHOLDER_POST
						keywords_map[placeholder] = keyword
						c = c:gsub("([^%w_])(" .. keyword .. ")([^%w_])", "%1" .. placeholder .. "%3")
						c = c:gsub("^(" .. keyword .. ")([^%w_])", placeholder .. "%2")
						c = c:gsub("([^%w_])(" .. keyword .. ")$", "%1" .. placeholder)
						c = c:gsub("^(" .. keyword .. ")$", placeholder)
					end
					return c
				end
				local function restoreKeywords(c)
					for placeholder, keyword in pairs(keywords_map) do
						c = string.gsub(c, placeholder, function()
							return keyword
						end)
					end
					return c
				end
				local function restoreStrings(c)
					for i = string_count, 1, -1 do
						local key = STR_PLACEHOLDER_PRE .. i .. STR_PLACEHOLDER_POST
						c = string.gsub(c, key, function()
							return strings[key]
						end)
					end
					return c
				end
				code = preserveStrings(code)
				code = preserveKeywords(code)
				code = code:gsub("--%[%[.-%]%]", "")
				code = code:gsub("%-%-[^\n]*", "")
				code = code:gsub("[\n\r]+", " ")
				code = code:gsub("%s+", " ")
				code = code:gsub("%s*%.%.%s*", "..")
				code = code:gsub("%s*([%+%-%*/%%\\^#%<%>%~%=%,%;:%(%){}%[%]])%s*", "%1")
				code = code:gsub("%s*%.%s*", ".")
				code = code:gsub("%.%.", "..")
				code = code:match("^%s*(.-)%s*$") or ""
				code = restoreKeywords(code)
				code = restoreStrings(code)
				return code
			end
			return Compressor
		end
		function _legacyluaprotector.k()
			local v = _legacyluaprotector.cache.k
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.k = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local StringToExpressions = {}
			local math_methods = {
				addSub = function(char, base1, base2)
					local base = math.random(base1, base2)
					local chance = math.random(0, 1)
					return chance == 1 and string.format("%d - (%d)", base, base - char)
						or string.format("%d + %d", char - base, base)
				end,
			}
			local used_ascii = {}
			local function insertChar(obfuscated, ascii_code, base1, base2)
				used_ascii[ascii_code] = true
				local part = math_methods.addSub(ascii_code, base1, base2)
				table.insert(obfuscated, "chars[" .. part .. "]")
			end
			local function formatChar(ascii_code)
				if ascii_code < 32 or ascii_code > 126 then
					return string.format("\\%03d", ascii_code)
				else
					return string.char(ascii_code)
				end
			end
			local function obfuscateStringLiteral(str, base1, base2)
				if #str == 0 then
					return '""'
				end
				local escape_chars = { n = 10, r = 13, t = 9, ["'"] = 39, ['"'] = 34 }
				local obfuscated = {}
				local i = 1
				while i <= #str do
					local char_code = str:byte(i)
					if char_code == 92 and i < #str then
						local next_char = str:sub(i + 1, i + 1)
						if next_char == "2" and str:sub(i + 2, i + 2) == "7" then
							insertChar(obfuscated, 27, base1, base2)
							i = i + 2
						elseif escape_chars[next_char] then
							insertChar(obfuscated, escape_chars[next_char], base1, base2)
							i = i + 1
						else
							insertChar(obfuscated, char_code, base1, base2)
							insertChar(obfuscated, str:sub(i + 1, i + 1):byte(), base1, base2)
							i = i + 1
						end
					else
						insertChar(obfuscated, char_code, base1, base2)
					end
					i = i + 1
				end
				return table.concat(obfuscated, "..")
			end
			function StringToExpressions.process(script_content, base1, base2)
				script_content = script_content:gsub('\\"', "!@!"):gsub("\\'", "@!@")
				local obfuscated_script = script_content:gsub("(['\"])(.-)%1", function(quote, str)
					str = str:gsub("!@!", '\\"'):gsub("@!@", "\\'")
					local obf = obfuscateStringLiteral(str, base1, base2)
					return obf
				end)
				local chars_table_parts = {}
				for ascii_code, _ in pairs(used_ascii) do
					chars_table_parts[#chars_table_parts + 1] =
						string.format("[%d]=%q", ascii_code, formatChar(ascii_code))
				end
				local chars_table = "local chars = {" .. table.concat(chars_table_parts, ",") .. "}\n"
				return chars_table .. obfuscated_script
			end
			return StringToExpressions
		end
		function _legacyluaprotector.l()
			local v = _legacyluaprotector.cache.l
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.l = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Wrapper = {}
			function Wrapper.process(code)
				return [[return (function(...) ]] .. code .. [[ end)(...)]]
			end
			return Wrapper
		end
		function _legacyluaprotector.m()
			local v = _legacyluaprotector.cache.m
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.m = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Parts = {
				Variables = [=[
            local LuaFunc, WrapState, BcToState, gChunk;
            local FIELDS_PER_FLUSH = 50
            local Select = select;
            local function CreateTbl(_) return {} end;
            local Unpack = unpack or table.unpack
            local function Pack(...)
                return {
                    n = Select('#', ...), ...
                }
            end
            local function Move(src, First, Last, Offset, Dst)
                for i = _, Last - First do
                    Dst[Offset + i] = src[First + i]
                end
            end
            local function BAnd(a, b)
                local result = _
                local bitval = __
                while a > _ and b > _ do
                    if (a % 2 == __) and (b % 2 == __) then
                        result = result + bitval
                    end
                    bitval = bitval * 2
                    a = math.floor(a / 2)
                    b = math.floor(b / 2)
                end
                return result
            end
            local function LShift(x, n)
                return x * 2 ^ n
            end
            local function RShift(x, n)
                return math.floor(x / 2 ^ n)
            end
            local function BOr(a, b)
                local result = _
                local shift = __
                while a > _ or b > _ do
                    local abit = a % 2
                    local bbit = b % 2
                    if abit == __ or bbit == __ then
                        result = result + shift
                    end
                    a = math.floor(a / 2)
                    b = math.floor(b / 2)
                    shift = shift * 2
                end
                return result
            end
            local function CloseLuaUpvalues(B, N)
                for i, uv in pairs(B) do
                    if uv.N >= N then
                        uv.m = uv.M[uv.N];
                        uv.M = uv;
                        uv.N = 'm'
                        B[i] = nil;
                    end;
                end;
            end;
            local function SenLuaUpvalue(B, N, X)
                local Prev = B[N]
                if not Prev then
                    Prev = { N = N, M = X }
                    B[N] = Prev;
                end;
                return Prev
            end;
            local function NormalizeNumber(value)
                if value % 1 == 0 then
                    return value
                end
                return value
            end
            local _orig_tostring = tostring
            function tostring(v)
                if type(v) == 'number' then
                    local s = _orig_tostring(v)
                    if not s:find('[%.eE]') then
                        return s .. '.0'
                    end
                    return s
                end
                return _orig_tostring(v)
            end
            local asciilookup = {}
            for i = 0, 255 do
                asciilookup[string.char(i)] = i
            end
            local function chartoascii(str, pos)
                pos = pos or 1
                local ch = str:sub(pos, pos)
                return asciilookup[ch]
            end
            ]=],
				Deserializer = [=[
            function BcToState(Bytecode, charset)
                local base, decoded = #charset, {}
                local decode_lookup = {}
                for i = 1, base do decode_lookup[charset:sub(i, i)] = i - 1 end
                for encoded_char in Bytecode:gmatch("([^_]+)") do
                    local n = 0
                    for i = 1, #encoded_char do n = n * base + decode_lookup[encoded_char:sub(i, i)] end
                    decoded[#decoded + 1] = string.char(n)
                end
                local bytes = {}
                for char in table.concat(decoded):gmatch("(.?)\\") do
                    if #char > 0 then
                        bytes[#bytes + 1] = chartoascii(char)
                    end
                end
                local Pos = 1
                local function gBits8()
                    local Val = bytes[Pos]
                    Pos = Pos + 1
                    return Val
                end
                local function gBits16()
                    local Val1, Val2 = bytes[Pos], bytes[Pos + 1]
                    Pos = Pos + 2
                    return (Val2 * 256) + Val1
                end
                local function gBits32()
                    local Val1, Val2, Val3, Val4 = bytes[Pos], bytes[Pos + 1], bytes[Pos + 2], bytes[Pos + 3]
                    Pos = Pos + 4
                    return (Val4 * 16777216) + (Val3 * 65536) + (Val2 * 256) + Val1
                end
                function gChunk()
                    local Chunk = {
                        n = gBits8(),
                        c = gBits8(),
                        d = gBits8(),
                        x = {},
                        D = {},
                        V = {}
                    }
                    for i = __, gBits32() do
                        local Data = gBits32()
                        local Sco = gBits8()
                        local Type = gBits8()
                        local Inst = {
                            m = Data,
                            S = Sco,
                            A = gBits16()
                        }
                        local Mode = {
                            b = gBits8(),
                            c = gBits8()
                        }
                        if (Type == __) then
                            Inst.B = gBits16()
                            Inst.C = gBits16()
                            Inst.s = Mode.b == __ and Inst.B > 0xFF
                            Inst.a = Mode.c == __ and Inst.C > 0xFF
                        elseif (Type == 2) then
                            Inst.F = gBits32()
                            Inst.g = Mode.b == __
                        elseif (Type == 3) then
                            Inst.f = gBits32() - 131071
                        end
                        Chunk.x[i] = Inst
                    end
                    for i = __, gBits32() do
                        local Type = gBits8()
                        if (Type == __) then
                            Chunk.D[i - __] = (gBits8() ~= _)
                        elseif (Type == 3) then
                            Chunk.D[i - __] = (function()
                                local Left = gBits32()
                                local Right = gBits32()
                                local IsNormal = __
                                local Mantissa = BOr(LShift(BAnd(Right, 0xFFFFF), 32), Left)
                                local Exponent = BAnd(RShift(Right, 20), 0x7FF)
                                local Sign = (-__) ^ RShift(Right, 31)
                                if Exponent == _ then
                                    if Mantissa == _ then
                                        return Sign * _
                                    else
                                        Exponent = __
                                        IsNormal = _
                                    end
                                elseif Exponent == 2047 then
                                    if Mantissa == _ then
                                        return Sign * (__ / _)
                                    else
                                        return Sign * (_ / _)
                                    end
                                end
                                local raw = math.ldexp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)))
                                return NormalizeNumber(raw)
                            end)()
                        elseif (Type == 4) then
                            Chunk.D[i - __] = (function()
                                local Str
                                local baik = gBits32()
                                if (baik == _) then return end
                                local chars = {}
                                for j = 1, baik do
                                    chars[#chars + 1] = string.char(gBits8())
                                end
                                return table.concat(chars)
                            end)()
                        end
                    end
                    for i = __, gBits32() do
                        Chunk.V[i - __] = gChunk()
                    end
                    for _, v in ipairs(Chunk.x) do
                        if v.g then
                            v.D = Chunk.D[v.F]
                        else
                            if v.s then
                                v.A = Chunk.D[v.B - 256]
                            end
                            if v.a then
                                v.C = Chunk.D[v.C - 256]
                            end
                        end
                    end
                    return Chunk
                end
                return gChunk()
            end
            ]=],
				Wrapper_1 = [=[
            function LuaFunc(State, Env, n)
                local x = State.x;
                local V = State.Z;
                local v = State.v;
                local Top = -__;
                local SenB = {}
                local X = State.X;
                local z = State.z;
                while alpha do
                    local Inst = x[z]
                    local S = Inst.S;
                    local C = Inst.C;
                    local A = Inst.A;
                    local B = Inst.B;
                    local D = Inst.D;
                    local F = Inst.F;
                    z = z + __;
            ]=],
				Wrapper_2 = [=[
                    State.z = z;
                end;
            end;
            function WrapState(V, Env, Upval)
                local function Wrapped(...)
                    local Passed = Pack(...)
                    local X = CreateTbl(V.d)
                    local v = { b = _, B = {} }
                    Move(Passed, __, V.c, _, X)
                    if (V.c < Passed.n) then
                        local Start = V.c + __
                        local b = Passed.n - V.c;
                        v.b = b;
                        Move(Passed, Start, Start + b - __, __, v.B)
                    end;
                    local State = {
                        v = v,
                        X = X,
                        x = V.x,
                        Z = V.V,
                        z = __
                    }
                    return LuaFunc(State, Env, Upval)
                end;
                return Wrapped;
            end;
            ]=],
			}
			return Parts
		end
		function _legacyluaprotector.n()
			local v = _legacyluaprotector.cache.n
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.n = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			function GetOpcodeCode(S)
				if S == 0 then
					return [=[X[Inst.A] = X[Inst.B];]=]
				elseif S == 1 then
					return [=[X[Inst.A] = (type(Inst.D) == "number" and Inst.D % 1 == 0) and math.floor(Inst.D) or Inst.D]=]
				elseif S == 2 then
					return [=[
                    X[Inst.A] = Inst.B ~= 0
                    if Inst.C ~= 0 then z = z + 1 end;
                    ]=]
				elseif S == 3 then
					return [=[
                    for i = Inst.A, Inst.B do X[i] = nil end;
                    ]=]
				elseif S == 4 then
					return [=[
                    local Uv = n[Inst.B]
                    X[Inst.A] = Uv.M[Uv.N]
                    ]=]
				elseif S == 5 then
					return [=[
                    X[Inst.A] = Env[Inst.D]
                    ]=]
				elseif S == 6 then
					return [=[
                    local N
                    if Inst.a then
                        N = Inst.C;
                    else
                        N = X[Inst.C]
                    end
                    X[Inst.A] = X[Inst.B][N]
                    ]=]
				elseif S == 7 then
					return [=[
                    Env[Inst.D] = X[Inst.A]
                    ]=]
				elseif S == 8 then
					return [=[
                    local Uv = n[Inst.B]
                    Uv.M[Uv.N] = X[Inst.A]
                    ]=]
				elseif S == 9 then
					return [=[
                    local N, m
                    if Inst.s then
                        N = Inst.A
                    else
                        N = X[Inst.B]
                    end
                    if Inst.a then
                        m = Inst.C
                    else
                        m = X[Inst.C]
                    end
                    X[Inst.A][N] = m
                    ]=]
				elseif S == 10 then
					return [=[
                    X[Inst.A] = {}
                    ]=]
				elseif S == 11 then
					return [=[
                    local A = Inst.A
                    local B = Inst.B
                    local N;
                    if Inst.a then
                        N = Inst.C
                    else
                        N = X[Inst.C]
                    end
                    X[A + 1] = X[B]
                    X[A] = X[B][N]
                    ]=]
				elseif S == 12 then
					return [=[
                    local Lhs, Rhs;
                    if Inst.s then
                        Lhs = Inst.A
                    else
                        Lhs = X[Inst.B]
                    end
                    if Inst.a then
                        Rhs = Inst.C
                    else
                        Rhs = X[Inst.C]
                    end
                    X[Inst.A] = NormalizeNumber(Lhs + Rhs)
                    ]=]
				elseif S == 13 then
					return [=[
                    local Lhs, Rhs;
                    if Inst.s then
                        Lhs = Inst.A
                    else
                        Lhs = X[Inst.B]
                    end
                    if Inst.a then
                        Rhs = Inst.C
                    else
                        Rhs = X[Inst.C]
                    end
                    X[Inst.A] = NormalizeNumber(Lhs - Rhs)
                    ]=]
				elseif S == 14 then
					return [=[
                    local Lhs, Rhs;
                    if Inst.s then
                        Lhs = Inst.A
                    else
                        Lhs = X[Inst.B]
                    end
                    if Inst.a then
                        Rhs = Inst.C
                    else
                        Rhs = X[Inst.C]
                    end
                    X[Inst.A] = NormalizeNumber(Lhs * Rhs)
                    ]=]
				elseif S == 15 then
					return [=[
                    local Lhs, Rhs;
                    if Inst.s then
                        Lhs = Inst.A
                    else
                        Lhs = X[Inst.B]
                    end
                    if Inst.a then
                        Rhs = Inst.C
                    else
                        Rhs = X[Inst.C]
                    end
                    X[Inst.A] = NormalizeNumber(Lhs / Rhs)
                    ]=]
				elseif S == 16 then
					return [=[
                    local Lhs, Rhs;
                    if Inst.s then
                        Lhs = Inst.A
                    else
                        Lhs = X[Inst.B]
                    end
                    if Inst.a then
                        Rhs = Inst.C
                    else
                        Rhs = X[Inst.C]
                    end
                    X[Inst.A] = NormalizeNumber(Lhs % Rhs)
                    ]=]
				elseif S == 17 then
					return [=[
                    local Lhs, Rhs;
                    if Inst.s then
                        Lhs = Inst.A
                    else
                        Lhs = X[Inst.B]
                    end
                    if Inst.a then
                        Rhs = Inst.C
                    else
                        Rhs = X[Inst.C]
                    end
                    X[Inst.A] = NormalizeNumber(Lhs ^ Rhs)
                    ]=]
				elseif S == 18 then
					return [=[
                    X[Inst.A] = NormalizeNumber(-X[Inst.B])
                    ]=]
				elseif S == 19 then
					return [=[
                    X[Inst.A] = not X[Inst.B]
                    ]=]
				elseif S == 20 then
					return [=[X[Inst.A] = #X[Inst.B]]=]
				elseif S == 21 then
					return [=[
                    local B, C = Inst.B, Inst.C;
                    local Str = "";
                    for i = B, C do
                        local v = X[i];
                        if type(v) == "number" then
                            if v % 1 == 0 then
                                Str = Str .. string.format("%d", v)
                            else
                                Str = Str .. string.format("%g", v)
                            end
                        else
                            Str = Str .. tostring(v)
                        end
                    end
                    X[Inst.A] = Str;
                ]=]
				elseif S == 22 then
					return [=[z = z + Inst.f]=]
				elseif S == 23 then
					return [=[
                    local Lhs, Rhs;
                    if Inst.s then
                        Lhs = Inst.A
                    else
                        Lhs = X[Inst.B]
                    end
                    if Inst.a then
                        Rhs = Inst.C
                    else
                        Rhs = X[Inst.C]
                    end
                    if (Lhs == Rhs) == (Inst.A ~= 0) then z = z + x[z].f end;
                    z = z + 1
                    ]=]
				elseif S == 24 then
					return [=[
                    local Lhs, Rhs;
                    if Inst.s then
                        Lhs = Inst.A
                    else
                        Lhs = X[Inst.B]
                    end
                    if Inst.a then
                        Rhs = Inst.C
                    else
                        Rhs = X[Inst.C]
                    end
                    if (Lhs < Rhs) == (Inst.A ~= 0) then z = z + x[z].f end;
                    z = z + 1
                    ]=]
				elseif S == 25 then
					return [=[
                    local Lhs, Rhs;
                    if Inst.s then
                        Lhs = Inst.A
                    else
                        Lhs = X[Inst.B]
                    end
                    if Inst.a then
                        Rhs = Inst.C
                    else
                        Rhs = X[Inst.C]
                    end
                    if (Lhs <= Rhs) == (Inst.A ~= 0) then z = z + x[z].f end;
                    z = z + 1
                    ]=]
				elseif S == 26 then
					return [=[
                    if (not X[Inst.A]) ~= (Inst.C ~= 0) then z = z + x[z].f end
                    z = z + 1
                    ]=]
				elseif S == 27 then
					return [=[
                    local A = Inst.A
                    local B = Inst.B;
                    if (not X[B]) ~= (Inst.C ~= 0) then
                        X[A] = X[B]
                        z = z + x[z].f
                    end;
                    z = z + 1
                    ]=]
				elseif S == 28 then
					return [=[
                    local A = Inst.A;
                    local B = Inst.B;
                    local Params;
                    if B == 0 then
                        Params = Top - A;
                    else
                        Params = B - 1;
                    end;
                    local RetB = Pack(X[A](Unpack(X, A + 1, A + Params)))
                    local RetNum = RetB.n;
                    if C == 0 then
                        Top = A + RetNum - 1;
                    else
                        RetNum = C - 1;
                    end;
                    Move(RetB, 1, RetNum, A, X)
                    ]=]
				elseif S == 29 then
					return [=[
                    local A = Inst.A;
                    local B = Inst.B;
                    local Params;
                    if B == 0 then
                        Params = Top - A;
                    else
                        Params = B - 1;
                    end;
                    CloseLuaUpvalues(SenB, 0)
                    return X[A](Unpack(X, A + 1, A + Params))
                    ]=]
				elseif S == 30 then
					return [=[
                    local A = Inst.A;
                    local b = Inst.B;
                    if B == 0 then        
                        b = Top - A + 1;
                    else
                        b = B - 1;
                    end;
                    CloseLuaUpvalues(SenB, 0)
                    return Unpack(X, A, A + b - 1)
                    ]=]
				elseif S == 31 then
					return [=[
                    local A = Inst.A;
                    local Step = X[A + 2]
                    local N = X[A] + Step;
                    local Limit = X[A + 1]
                    local Loops
                    if Step == math.abs(Step) then
                        Loops = N <= Limit;
                    else
                        Loops = N >= Limit;
                    end;
                    if Loops then
                        X[A] = N;
                        X[A + 3] = N;
                        z = z + Inst.f;
                    end;
                    ]=]
				elseif S == 32 then
					return [=[
                    local A = Inst.A;
                    local Init, Limit, Step;
                    Init = tonumber(X[A])
                    Limit = tonumber(X[A + 1])
                    Step = tonumber(X[A + 2])
                    X[A] = Init - Step;
                    X[A + 1] = Limit;
                    X[A + 2] = Step;
                    z = z + Inst.f;
                    ]=]
				elseif S == 33 then
					return [=[
                    local A = Inst.A;
                    local Base = A + 3;
                    local Vals = {X[A](X[A + 1], X[A + 2])}
                    Move(Vals, 1, Inst.C, Base, X)
                    if X[Base] ~= nil then
                        X[A + 2] = X[Base]
                        z = z + x[z].f;
                    end;
                    z = z + 1
                    ]=]
				elseif S == 34 then
					return [=[
                    local A = Inst.A
                    local C = Inst.C
                    local b = Inst.B;
                    local Tab = X[A]
                    local Offset;
                    if b == 0 then b = Top - A end
                    if C == 0 then
                        C = x[z].m;
                        z = z + 1
                    end;
                    Offset = (C - 1) * FIELDS_PER_FLUSH
                    Move(X, A + 1, A + b, Offset + 1, Tab)
                    ]=]
				elseif S == 35 then
					return [=[CloseLuaUpvalues(SenB, Inst.A)]=]
				elseif S == 36 then
					return [=[
                    local Sub = V[Inst.F]
                    local Nups = Sub.n;
                    local UvB;
                    if Nups ~= 0 then
                        UvB = CreateTbl(Nups - 1)
                        for i = 1, Nups do
                            local Pseudo = x[z + i - 1]
                            if (Pseudo.S == 0) then
                                UvB[i - 1] = SenLuaUpvalue(SenB, Pseudo.B, X)
                            elseif (Pseudo.S == 4) then
                                UvB[i - 1] = n[Pseudo.B]
                            end;
                        end;
                        z = z + Nups
                    end;
                    X[Inst.A] = WrapState(Sub, Env, UvB)
                    ]=]
				elseif S == 37 then
					return [=[
                    local A = Inst.A;
                    local b = Inst.B;
                    if (b == 0) then
                        b = v.b;
                        Top = A + b - 1;
                    end;
                    Move(v.B, 1, b, A, X)
                    ]=]
				end
			end
			return GetOpcodeCode
		end
		function _legacyluaprotector.o()
			local v = _legacyluaprotector.cache.o
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.o = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local bit = {}
			function bit.band(a, b)
				local result = 0
				local bitval = 1
				while a > 0 and b > 0 do
					if (a % 2 == 1) and (b % 2 == 1) then
						result = result + bitval
					end
					bitval = bitval * 2
					a = math.floor(a / 2)
					b = math.floor(b / 2)
				end
				return result
			end
			function bit.lshift(x, n)
				return x * 2 ^ n
			end
			function bit.rshift(x, n)
				return math.floor(x / 2 ^ n)
			end
			return bit
		end
		function _legacyluaprotector.p()
			local v = _legacyluaprotector.cache.p
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.p = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local bit = _legacyluaprotector.p()
			function Serialize(Chunk)
				local Buffer = {}
				local function AddByte(Value)
					table.insert(Buffer, string.char(Value) .. "\\")
				end
				local function WriteBits8(Value)
					AddByte(Value)
				end
				local function WriteBits16(Value)
					for i = 0, 1 do
						AddByte(bit.band(bit.rshift(Value, i * 8), 255))
					end
				end
				local function WriteBits32(Value)
					for i = 0, 3 do
						AddByte(bit.band(bit.rshift(Value, i * 8), 255))
					end
				end
				local function WriteFloat64(value)
					local sign = 0
					if value < 0 or (value == 0 and 1 / value == -math.huge) then
						sign = 1
					end
					local mantissa, exponent = math.frexp(math.abs(value))
					if value == 0 then
						exponent, mantissa = 0, 0
					elseif value == math.huge then
						exponent, mantissa = 2047, 0
					elseif value ~= value then
						exponent, mantissa = 2047, 1
					else
						mantissa = (mantissa * 2 - 1) * 2 ^ 52
						exponent = exponent + 1022
					end
					local high = sign * 2 ^ 31 + exponent * 2 ^ 20 + math.floor(mantissa / 2 ^ 32)
					local low = mantissa % 2 ^ 32
					WriteBits32(low)
					WriteBits32(high)
				end
				local function WriteString(Str)
					WriteBits32(#Str)
					for i = 1, #Str do
						WriteBits8(string.byte(Str, i))
					end
				end
				local function WriteChunk(SubChunk)
					WriteBits8(SubChunk.Upvals)
					WriteBits8(SubChunk.Parameters)
					WriteBits8(SubChunk.MaxStack)
					WriteBits32(#SubChunk.Instructions)
					for i = 1, #SubChunk.Instructions do
						local Inst = SubChunk.Instructions[i]
						local Data = Inst.Value
						local Enum = Inst.Enum
						local Type = Inst.Type
						local Mode = Inst.Mode
						WriteBits32(Data)
						WriteBits8(Enum)
						WriteBits8((Type == "ABC" and 1) or (Type == "ABx" and 2) or (Type == "AsBx" and 3))
						WriteBits16(Inst.A)
						if Mode.b == "OpArgK" then
							WriteBits8(1)
						elseif Mode.b == "OpArgN" then
							WriteBits8(0)
						elseif Mode.b == "OpArgU" then
							WriteBits8(0)
						elseif Mode.b == "OpArgR" then
							WriteBits8(0)
						end
						if Mode.c == "OpArgK" then
							WriteBits8(1)
						elseif Mode.c == "OpArgN" then
							WriteBits8(0)
						elseif Mode.c == "OpArgU" then
							WriteBits8(0)
						elseif Mode.c == "OpArgR" then
							WriteBits8(0)
						end
						if Type == "ABC" then
							WriteBits16(Inst.B)
							WriteBits16(Inst.C)
						elseif Type == "ABx" then
							WriteBits32(Inst.Bx)
						elseif Type == "AsBx" then
							WriteBits32(Inst.sBx + 131071)
						end
					end
					WriteBits32(#SubChunk.Constants)
					for i = 1, #SubChunk.Constants do
						local Const = SubChunk.Constants[i]
						local Type = type(Const)
						if Type == "boolean" then
							WriteBits8(1)
							WriteBits8(Const and 1 or 0)
						elseif Type == "number" then
							WriteBits8(3)
							WriteFloat64(Const)
						elseif Type == "string" then
							WriteBits8(4)
							WriteString(Const)
						end
					end
					WriteBits32(#SubChunk.Protos)
					for i = 1, #SubChunk.Protos do
						WriteChunk(SubChunk.Protos[i])
					end
				end
				WriteChunk(Chunk)
				return table.concat(Buffer)
			end
			return Serialize
		end
		function _legacyluaprotector.q()
			local v = _legacyluaprotector.cache.q
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.q = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local bit = _legacyluaprotector.p()
			_G.UsedOps = {}
			if not table.create then
				function table.create(_)
					return {}
				end
			end
			local lua_bc_to_state
			local stm_lua_func
			local OPCODE_T = {
				[0] = "ABC",
				"ABx",
				"ABC",
				"ABC",
				"ABC",
				"ABx",
				"ABC",
				"ABx",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"AsBx",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"ABC",
				"AsBx",
				"AsBx",
				"ABC",
				"ABC",
				"ABC",
				"ABx",
				"ABC",
			}
			local OPCODE_M = {
				[0] = {
					b = "OpArgR",
					c = "OpArgN",
				},
				{
					b = "OpArgK",
					c = "OpArgN",
				},
				{
					b = "OpArgU",
					c = "OpArgU",
				},
				{
					b = "OpArgR",
					c = "OpArgN",
				},
				{
					b = "OpArgU",
					c = "OpArgN",
				},
				{
					b = "OpArgK",
					c = "OpArgN",
				},
				{
					b = "OpArgR",
					c = "OpArgK",
				},
				{
					b = "OpArgK",
					c = "OpArgN",
				},
				{
					b = "OpArgU",
					c = "OpArgN",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgU",
					c = "OpArgU",
				},
				{
					b = "OpArgR",
					c = "OpArgK",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgR",
					c = "OpArgN",
				},
				{
					b = "OpArgR",
					c = "OpArgN",
				},
				{
					b = "OpArgR",
					c = "OpArgN",
				},
				{
					b = "OpArgR",
					c = "OpArgR",
				},
				{
					b = "OpArgR",
					c = "OpArgN",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgK",
					c = "OpArgK",
				},
				{
					b = "OpArgR",
					c = "OpArgU",
				},
				{
					b = "OpArgR",
					c = "OpArgU",
				},
				{
					b = "OpArgU",
					c = "OpArgU",
				},
				{
					b = "OpArgU",
					c = "OpArgU",
				},
				{
					b = "OpArgU",
					c = "OpArgN",
				},
				{
					b = "OpArgR",
					c = "OpArgN",
				},
				{
					b = "OpArgR",
					c = "OpArgN",
				},
				{
					b = "OpArgN",
					c = "OpArgU",
				},
				{
					b = "OpArgU",
					c = "OpArgU",
				},
				{
					b = "OpArgN",
					c = "OpArgN",
				},
				{
					b = "OpArgU",
					c = "OpArgN",
				},
				{
					b = "OpArgU",
					c = "OpArgN",
				},
			}
			local function rd_int_basic(src, s, e, d)
				local num = 0
				for i = s, e, d do
					local mul = 256 ^ math.abs(i - s)
					num = num + mul * string.byte(src, i, i)
				end
				return num
			end
			local function rd_flt_basic(f1, f2, f3, f4)
				local sign = (-1) ^ bit.rshift(f4, 7)
				local exp = bit.rshift(f3, 7) + bit.lshift(bit.band(f4, 127), 1)
				local frac = f1 + bit.lshift(f2, 8) + bit.lshift(bit.band(f3, 127), 16)
				local normal = 1
				if exp == 0 then
					if frac == 0 then
						return sign * 0
					else
						normal = 0
						exp = 1
					end
				elseif exp == 127 then
					if frac == 0 then
						return sign * (1 / 0)
					else
						return sign * (0 / 0)
					end
				end
				return sign * 2 ^ (exp - 127) * (1 + normal / 2 ^ 23)
			end
			local function rd_dbl_basic(f1, f2, f3, f4, f5, f6, f7, f8)
				local sign = (-1) ^ bit.rshift(f8, 7)
				local exp = bit.lshift(bit.band(f8, 127), 4) + bit.rshift(f7, 4)
				local frac = bit.band(f7, 15) * 2 ^ 48
				local normal = 1
				frac = frac + (f6 * 2 ^ 40) + (f5 * 2 ^ 32) + (f4 * 2 ^ 24) + (f3 * 2 ^ 16) + (f2 * 2 ^ 8) + f1
				if exp == 0 then
					if frac == 0 then
						return sign * 0
					else
						normal = 0
						exp = 1
					end
				elseif exp == 2047 then
					if frac == 0 then
						return sign * (1 / 0)
					else
						return sign * (0 / 0)
					end
				end
				return sign * 2 ^ (exp - 1023) * (normal + frac / 2 ^ 52)
			end
			local function rd_int_le(src, s, e)
				return rd_int_basic(src, s, e - 1, 1)
			end
			local function rd_int_be(src, s, e)
				return rd_int_basic(src, e - 1, s, -1)
			end
			local function rd_flt_le(src, s)
				return rd_flt_basic(string.byte(src, s, s + 3))
			end
			local function rd_flt_be(src, s)
				local f1, f2, f3, f4 = string.byte(src, s, s + 3)
				return rd_flt_basic(f4, f3, f2, f1)
			end
			local function rd_dbl_le(src, s)
				return rd_dbl_basic(string.byte(src, s, s + 7))
			end
			local function rd_dbl_be(src, s)
				local f1, f2, f3, f4, f5, f6, f7, f8 = string.byte(src, s, s + 7)
				return rd_dbl_basic(f8, f7, f6, f5, f4, f3, f2, f1)
			end
			local float_types = {
				[4] = {
					little = rd_flt_le,
					big = rd_flt_be,
				},
				[8] = {
					little = rd_dbl_le,
					big = rd_dbl_be,
				},
			}
			local function stm_byte(S)
				local idx = S.index
				local bt = string.byte(S.source, idx, idx)
				S.index = idx + 1
				return bt
			end
			local function stm_string(S, len)
				local pos = S.index + len
				local str = string.sub(S.source, S.index, pos - 1)
				S.index = pos
				return str
			end
			local function stm_lstring(S)
				local len = S:s_szt()
				local str
				if len ~= 0 then
					str = string.sub(stm_string(S, len), 1, -2)
				end
				return str
			end
			local function cst_int_rdr(len, func)
				return function(S)
					local pos = S.index + len
					local int = func(S.source, S.index, pos)
					S.index = pos
					return int
				end
			end
			local function cst_flt_rdr(len, func)
				return function(S)
					local flt = func(S.source, S.index)
					S.index = S.index + len
					return flt
				end
			end
			local function stm_inst_list(S)
				local len = S:s_int()
				local list = table.create(len)
				for i = 1, len do
					local ins = S:s_ins()
					local op = bit.band(ins, 63)
					local args = OPCODE_T[op]
					local mode = OPCODE_M[op]
					local data = {
						Value = ins,
						Enum = op,
						Type = args,
						Mode = mode,
						A = bit.band(bit.rshift(ins, 6), 255),
					}
					if args == "ABC" then
						data.B = bit.band(bit.rshift(ins, 23), 511)
						data.C = bit.band(bit.rshift(ins, 14), 511)
					elseif args == "ABx" then
						data.Bx = bit.band(bit.rshift(ins, 14), 262143)
					elseif args == "AsBx" then
						data.sBx = bit.band(bit.rshift(ins, 14), 262143) - 131071
					end
					if not _G.UsedOps[op] then
						_G.UsedOps[op] = op
					end
					list[i] = data
				end
				return list
			end
			local function stm_const_list(S)
				local len = S:s_int()
				local list = table.create(len)
				for i = 1, len do
					local tt = stm_byte(S)
					local k
					if tt == 1 then
						k = stm_byte(S) ~= 0
					elseif tt == 3 then
						k = S:s_num()
					elseif tt == 4 then
						k = stm_lstring(S)
					end
					list[i] = k
				end
				return list
			end
			local function stm_sub_list(S, src)
				local len = S:s_int()
				local list = table.create(len)
				for i = 1, len do
					list[i] = stm_lua_func(S, src)
				end
				return list
			end
			local function stm_line_list(S)
				local len = S:s_int()
				local list = table.create(len)
				for i = 1, len do
					list[i] = S:s_int()
				end
				return list
			end
			local function stm_loc_list(S)
				local len = S:s_int()
				local list = table.create(len)
				for i = 1, len do
					list[i] = {
						varname = stm_lstring(S),
						startpc = S:s_int(),
						endpc = S:s_int(),
					}
				end
				return list
			end
			local function stm_upval_list(S)
				local len = S:s_int()
				local list = table.create(len)
				for i = 1, len do
					list[i] = stm_lstring(S)
				end
				return list
			end
			function stm_lua_func(S, psrc)
				local proto = {}
				local src = stm_lstring(S) or psrc
				proto.SourceName = src
				S:s_int()
				S:s_int()
				proto.Upvals = stm_byte(S)
				proto.Parameters = stm_byte(S)
				stm_byte(S)
				proto.MaxStack = stm_byte(S)
				proto.Instructions = stm_inst_list(S)
				proto.Constants = stm_const_list(S)
				proto.Protos = stm_sub_list(S, src)
				stm_line_list(S)
				stm_loc_list(S)
				stm_upval_list(S)
				return proto
			end
			function Deserialize(src)
				local rdr_func
				local little
				local size_int
				local size_szt
				local size_ins
				local size_num
				local flag_int
				local stream = {
					index = 1,
					source = src,
				}
				assert(stm_string(stream, 4) == "\27Lua", "invalid Lua signature")
				assert(stm_byte(stream) == 81, "invalid Lua version")
				assert(stm_byte(stream) == 0, "invalid Lua format")
				little = stm_byte(stream) ~= 0
				size_int = stm_byte(stream)
				size_szt = stm_byte(stream)
				size_ins = stm_byte(stream)
				size_num = stm_byte(stream)
				flag_int = stm_byte(stream) ~= 0
				rdr_func = little and rd_int_le or rd_int_be
				stream.s_int = cst_int_rdr(size_int, rdr_func)
				stream.s_szt = cst_int_rdr(size_szt, rdr_func)
				stream.s_ins = cst_int_rdr(size_ins, rdr_func)
				if flag_int then
					stream.s_num = cst_int_rdr(size_num, rdr_func)
				elseif float_types[size_num] then
					stream.s_num = cst_flt_rdr(size_num, float_types[size_num][little and "little" or "big"])
				else
					error("unsupported float size")
				end
				return stm_lua_func(stream, "@virtual")
			end
			return Deserialize
		end
		function _legacyluaprotector.r()
			local v = _legacyluaprotector.cache.r
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.r = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Serialize = _legacyluaprotector.q()
			local Deserialize = _legacyluaprotector.r()
			local luaZ = {}
			local luaY = {}
			local luaX = {}
			local luaP = {}
			local luaU = {}
			local luaK = {}
			local size_size_t = 8
			local function lua_assert(test)
				if not test then
					error("assertion failed!")
				end
			end
			function luaZ:make_getS(buff)
				local b = buff
				return function()
					if not b then
						return nil
					end
					local data = b
					b = nil
					return data
				end
			end
			function luaZ:make_getF(source)
				local LUAL_BUFFERSIZE = 512
				local pos = 1
				return function()
					local buff = source:sub(pos, pos + LUAL_BUFFERSIZE - 1)
					pos = math.min(#source + 1, pos + LUAL_BUFFERSIZE)
					return buff
				end
			end
			function luaZ:init(reader, data)
				if not reader then
					return
				end
				local z = {}
				z.reader = reader
				z.data = data or ""
				z.name = ""
				if not data or data == "" then
					z.n = 0
				else
					z.n = #data
				end
				z.p = 0
				return z
			end
			function luaZ:fill(z)
				local buff = z.reader()
				z.data = buff
				if not buff or buff == "" then
					return "EOZ"
				end
				z.n, z.p = #buff - 1, 1
				return string.sub(buff, 1, 1)
			end
			function luaZ:zgetc(z)
				local n, p = z.n, z.p + 1
				if n > 0 then
					z.n, z.p = n - 1, p
					return string.sub(z.data, p, p)
				else
					return self:fill(z)
				end
			end
			luaX.RESERVED = [[
            	TK_AND and
            	TK_BREAK break
            	TK_DO do
            	TK_ELSE else
            	TK_ELSEIF elseif
            	TK_END end
            	TK_FALSE false
            	TK_FOR for
            	TK_FUNCTION function
            	TK_IF if
            	TK_IN in
            	TK_LOCAL local
            	TK_NIL nil
            	TK_NOT not
            	TK_OR or
            	TK_REPEAT repeat
            	TK_RETURN return
            	TK_THEN then
            	TK_TRUE true
            	TK_UNTIL until
            	TK_WHILE while
            	TK_CONCAT ..
            	TK_DOTS ...
            	TK_EQ ==
            	TK_GE >=
            	TK_LE <=
            	TK_NE ~=
            	TK_NAME <name>
            	TK_NUMBER <number>
            	TK_STRING <string>
            	TK_EOS <eof>]]
			luaX.MAXSRC = 80
			luaX.MAX_INT = 2147483645
			luaX.LUA_QS = "'%s'"
			luaX.LUA_COMPAT_LSTR = 1
			function luaX:init()
				local tokens, enums = {}, {}
				for v in string.gmatch(self.RESERVED, "[^\n]+") do
					local _, _, tok, str = string.find(v, "(%S+)%s+(%S+)")
					tokens[tok] = str
					enums[str] = tok
				end
				self.tokens = tokens
				self.enums = enums
			end
			function luaX:chunkid(source, bufflen)
				local out
				local first = string.sub(source, 1, 1)
				if first == "=" then
					out = string.sub(source, 2, bufflen)
				else
					if first == "@" then
						source = string.sub(source, 2)
						bufflen = bufflen - #" '...' "
						local l = #source
						out = ""
						if l > bufflen then
							source = string.sub(source, 1 + l - bufflen)
							out = out .. "..."
						end
						out = out .. source
					else
						local len = string.find(source, "[\n\r]")
						len = len and (len - 1) or #source
						bufflen = bufflen - #' [string "..."] '
						if len > bufflen then
							len = bufflen
						end
						out = '[string "'
						if len < #source then
							out = out .. string.sub(source, 1, len) .. "..."
						else
							out = out .. source
						end
						out = out .. '"]'
					end
				end
				return out
			end
			function luaX:token2str(ls, token)
				if string.sub(token, 1, 3) ~= "TK_" then
					if string.find(token, "%c") then
						return string.format("char(%d)", string.byte(token))
					end
					return token
				else
					return self.tokens[token]
				end
			end
			function luaX:lexerror(ls, msg, token)
				local function txtToken(ls, token)
					if token == "TK_NAME" or token == "TK_STRING" or token == "TK_NUMBER" then
						return ls.buff
					else
						return self:token2str(ls, token)
					end
				end
				local buff = self:chunkid(ls.source, self.MAXSRC)
				local msg = string.format("%s:%d: %s", buff, ls.linenumber, msg)
				if token then
					msg = string.format("%s near " .. self.LUA_QS, msg, txtToken(ls, token))
				end
				error(msg)
			end
			function luaX:syntaxerror(ls, msg)
				self:lexerror(ls, msg, ls.t.token)
			end
			function luaX:currIsNewline(ls)
				return ls.current == "\n" or ls.current == "\r"
			end
			function luaX:inclinenumber(ls)
				local old = ls.current
				self:nextc(ls)
				if self:currIsNewline(ls) and ls.current ~= old then
					self:nextc(ls)
				end
				ls.linenumber = ls.linenumber + 1
				if ls.linenumber >= self.MAX_INT then
					self:syntaxerror(ls, "chunk has too many lines")
				end
			end
			function luaX:setinput(L, ls, z, source)
				if not ls then
					ls = {}
				end
				if not ls.lookahead then
					ls.lookahead = {}
				end
				if not ls.t then
					ls.t = {}
				end
				ls.decpoint = "."
				ls.L = L
				ls.lookahead.token = "TK_EOS"
				ls.z = z
				ls.fs = nil
				ls.linenumber = 1
				ls.lastline = 1
				ls.source = source
				self:nextc(ls)
			end
			function luaX:check_next(ls, set)
				if not string.find(set, ls.current, 1, 1) then
					return false
				end
				self:save_and_next(ls)
				return true
			end
			function luaX:next(ls)
				ls.lastline = ls.linenumber
				if ls.lookahead.token ~= "TK_EOS" then
					ls.t.seminfo = ls.lookahead.seminfo
					ls.t.token = ls.lookahead.token
					ls.lookahead.token = "TK_EOS"
				else
					ls.t.token = self:llex(ls, ls.t)
				end
			end
			function luaX:lookahead(ls)
				ls.lookahead.token = self:llex(ls, ls.lookahead)
			end
			function luaX:nextc(ls)
				local c = luaZ:zgetc(ls.z)
				ls.current = c
				return c
			end
			function luaX:save(ls, c)
				local buff = ls.buff
				ls.buff = buff .. c
			end
			function luaX:save_and_next(ls)
				self:save(ls, ls.current)
				return self:nextc(ls)
			end
			function luaX:str2d(s)
				local result = tonumber(s)
				if result then
					return result
				end
				if string.lower(string.sub(s, 1, 2)) == "0x" then
					result = tonumber(s, 16)
					if result then
						return result
					end
				end
				return nil
			end
			function luaX:buffreplace(ls, from, to)
				local result, buff = "", ls.buff
				for p = 1, #buff do
					local c = string.sub(buff, p, p)
					if c == from then
						c = to
					end
					result = result .. c
				end
				ls.buff = result
			end
			function luaX:trydecpoint(ls, Token)
				local old = ls.decpoint
				self:buffreplace(ls, old, ls.decpoint)
				local seminfo = self:str2d(ls.buff)
				Token.seminfo = seminfo
				if not seminfo then
					self:buffreplace(ls, ls.decpoint, ".")
					self:lexerror(ls, "malformed number", "TK_NUMBER")
				end
			end
			function luaX:read_numeral(ls, Token)
				repeat
					self:save_and_next(ls)
				until string.find(ls.current, "%D") and ls.current ~= "."
				if self:check_next(ls, "Ee") then
					self:check_next(ls, "+-")
				end
				while string.find(ls.current, "^%w$") or ls.current == "_" do
					self:save_and_next(ls)
				end
				self:buffreplace(ls, ".", ls.decpoint)
				local seminfo = self:str2d(ls.buff)
				Token.seminfo = seminfo
				if not seminfo then
					self:trydecpoint(ls, Token)
				end
			end
			function luaX:skip_sep(ls)
				local count = 0
				local s = ls.current
				self:save_and_next(ls)
				while ls.current == "=" do
					self:save_and_next(ls)
					count = count + 1
				end
				return (ls.current == s) and count or -count - 1
			end
			function luaX:read_long_string(ls, Token, sep)
				local cont = 0
				self:save_and_next(ls)
				if self:currIsNewline(ls) then
					self:inclinenumber(ls)
				end
				while true do
					local c = ls.current
					if c == "EOZ" then
						self:lexerror(ls, Token and "unfinished long string" or "unfinished long comment", "TK_EOS")
					elseif c == "[" then
						if self.LUA_COMPAT_LSTR then
							if self:skip_sep(ls) == sep then
								self:save_and_next(ls)
								cont = cont + 1
								if self.LUA_COMPAT_LSTR == 1 then
									if sep == 0 then
										self:lexerror(ls, "nesting of [[...]] is deprecated", "[")
									end
								end
							end
						end
					elseif c == "]" then
						if self:skip_sep(ls) == sep then
							self:save_and_next(ls)
							if self.LUA_COMPAT_LSTR and self.LUA_COMPAT_LSTR == 2 then
								cont = cont - 1
								if sep == 0 and cont >= 0 then
									break
								end
							end
							break
						end
					elseif self:currIsNewline(ls) then
						self:save(ls, "\n")
						self:inclinenumber(ls)
						if not Token then
							ls.buff = ""
						end
					else
						if Token then
							self:save_and_next(ls)
						else
							self:nextc(ls)
						end
					end
				end
				if Token then
					local p = 3 + sep
					Token.seminfo = string.sub(ls.buff, p, -p)
				end
			end
			function luaX:read_string(ls, del, Token)
				self:save_and_next(ls)
				while ls.current ~= del do
					local c = ls.current
					if c == "EOZ" then
						self:lexerror(ls, "unfinished string", "TK_EOS")
					elseif self:currIsNewline(ls) then
						self:lexerror(ls, "unfinished string", "TK_STRING")
					elseif c == "\\" then
						c = self:nextc(ls)
						if self:currIsNewline(ls) then
							self:save(ls, "\n")
							self:inclinenumber(ls)
						elseif c ~= "EOZ" then
							local i = string.find("abfnrtv", c, 1, 1)
							if i then
								self:save(ls, string.sub("\a\b\f\n\r\t\v", i, i))
								self:nextc(ls)
							elseif not string.find(c, "%d") then
								self:save_and_next(ls)
							else
								c, i = 0, 0
								repeat
									c = 10 * c + ls.current
									self:nextc(ls)
									i = i + 1
								until i >= 3 or not string.find(ls.current, "%d")
								if c > 255 then
									self:lexerror(ls, "escape sequence too large", "TK_STRING")
								end
								self:save(ls, string.char(c))
							end
						end
					else
						self:save_and_next(ls)
					end
				end
				self:save_and_next(ls)
				Token.seminfo = string.sub(ls.buff, 2, -2)
			end
			function luaX:llex(ls, Token)
				ls.buff = ""
				while true do
					local c = ls.current
					if self:currIsNewline(ls) then
						self:inclinenumber(ls)
					elseif c == "-" then
						c = self:nextc(ls)
						if c ~= "-" then
							return "-"
						end
						local sep = -1
						if self:nextc(ls) == "[" then
							sep = self:skip_sep(ls)
							ls.buff = ""
						end
						if sep >= 0 then
							self:read_long_string(ls, nil, sep)
							ls.buff = ""
						else
							while not self:currIsNewline(ls) and ls.current ~= "EOZ" do
								self:nextc(ls)
							end
						end
					elseif c == "[" then
						local sep = self:skip_sep(ls)
						if sep >= 0 then
							self:read_long_string(ls, Token, sep)
							return "TK_STRING"
						elseif sep == -1 then
							return "["
						else
							self:lexerror(ls, "invalid long string delimiter", "TK_STRING")
						end
					elseif c == "=" then
						c = self:nextc(ls)
						if c ~= "=" then
							return "="
						else
							self:nextc(ls)
							return "TK_EQ"
						end
					elseif c == "<" then
						c = self:nextc(ls)
						if c ~= "=" then
							return "<"
						else
							self:nextc(ls)
							return "TK_LE"
						end
					elseif c == ">" then
						c = self:nextc(ls)
						if c ~= "=" then
							return ">"
						else
							self:nextc(ls)
							return "TK_GE"
						end
					elseif c == "~" then
						c = self:nextc(ls)
						if c ~= "=" then
							return "~"
						else
							self:nextc(ls)
							return "TK_NE"
						end
					elseif c == '"' or c == "'" then
						self:read_string(ls, c, Token)
						return "TK_STRING"
					elseif c == "." then
						c = self:save_and_next(ls)
						if self:check_next(ls, ".") then
							if self:check_next(ls, ".") then
								return "TK_DOTS"
							else
								return "TK_CONCAT"
							end
						elseif not string.find(c, "%d") then
							return "."
						else
							self:read_numeral(ls, Token)
							return "TK_NUMBER"
						end
					elseif c == "EOZ" then
						return "TK_EOS"
					else
						if string.find(c, "%s") then
							self:nextc(ls)
						elseif string.find(c, "%d") then
							self:read_numeral(ls, Token)
							return "TK_NUMBER"
						elseif string.find(c, "[_%a]") then
							repeat
								c = self:save_and_next(ls)
							until c == "EOZ" or not string.find(c, "[_%w]")
							local ts = ls.buff
							local tok = self.enums[ts]
							if tok then
								return tok
							end
							Token.seminfo = ts
							return "TK_NAME"
						else
							self:nextc(ls)
							return c
						end
					end
				end
			end
			luaP.OpMode = {
				iABC = 0,
				iABx = 1,
				iAsBx = 2,
			}
			luaP.SIZE_C = 9
			luaP.SIZE_B = 9
			luaP.SIZE_Bx = luaP.SIZE_C + luaP.SIZE_B
			luaP.SIZE_A = 8
			luaP.SIZE_OP = 6
			luaP.POS_OP = 0
			luaP.POS_A = luaP.POS_OP + luaP.SIZE_OP
			luaP.POS_C = luaP.POS_A + luaP.SIZE_A
			luaP.POS_B = luaP.POS_C + luaP.SIZE_C
			luaP.POS_Bx = luaP.POS_C
			luaP.MAXARG_Bx = math.ldexp(1, luaP.SIZE_Bx) - 1
			luaP.MAXARG_sBx = math.floor(luaP.MAXARG_Bx / 2)
			luaP.MAXARG_A = math.ldexp(1, luaP.SIZE_A) - 1
			luaP.MAXARG_B = math.ldexp(1, luaP.SIZE_B) - 1
			luaP.MAXARG_C = math.ldexp(1, luaP.SIZE_C) - 1
			function luaP:GET_OPCODE(i)
				return self.ROpCode[i.OP]
			end
			function luaP:SET_OPCODE(i, o)
				i.OP = self.OpCode[o]
			end
			function luaP:GETARG_A(i)
				return i.A
			end
			function luaP:SETARG_A(i, u)
				i.A = u
			end
			function luaP:GETARG_B(i)
				return i.B
			end
			function luaP:SETARG_B(i, b)
				i.B = b
			end
			function luaP:GETARG_C(i)
				return i.C
			end
			function luaP:SETARG_C(i, b)
				i.C = b
			end
			function luaP:GETARG_Bx(i)
				return i.Bx
			end
			function luaP:SETARG_Bx(i, b)
				i.Bx = b
			end
			function luaP:GETARG_sBx(i)
				return i.Bx - self.MAXARG_sBx
			end
			function luaP:SETARG_sBx(i, b)
				i.Bx = b + self.MAXARG_sBx
			end
			function luaP:CREATE_ABC(o, a, b, c)
				return {
					OP = self.OpCode[o],
					A = a,
					B = b,
					C = c,
				}
			end
			function luaP:CREATE_ABx(o, a, bc)
				return {
					OP = self.OpCode[o],
					A = a,
					Bx = bc,
				}
			end
			function luaP:CREATE_Inst(c)
				local o = c % 64
				c = (c - o) / 64
				local a = c % 256
				c = (c - a) / 256
				return self:CREATE_ABx(o, a, c)
			end
			function luaP:Instruction(i)
				if i.Bx then
					i.C = i.Bx % 512
					i.B = (i.Bx - i.C) / 512
				end
				local I = i.A * 64 + i.OP
				local c0 = I % 256
				I = i.C * 64 + (I - c0) / 256
				local c1 = I % 256
				I = i.B * 128 + (I - c1) / 256
				local c2 = I % 256
				local c3 = (I - c2) / 256
				return string.char(c0, c1, c2, c3)
			end
			function luaP:DecodeInst(x)
				local byte = string.byte
				local i = {}
				local I = byte(x, 1)
				local op = I % 64
				i.OP = op
				I = byte(x, 2) * 4 + (I - op) / 64
				local a = I % 256
				i.A = a
				I = byte(x, 3) * 4 + (I - a) / 256
				local c = I % 512
				i.C = c
				i.B = byte(x, 4) * 2 + (I - c) / 512
				local opmode = self.OpMode[tonumber(string.sub(self.opmodes[op + 1], 7, 7))]
				if opmode ~= "iABC" then
					i.Bx = i.B * 512 + i.C
				end
				return i
			end
			luaP.BITRK = math.ldexp(1, luaP.SIZE_B - 1)
			function luaP:ISK(x)
				return x >= self.BITRK
			end
			function luaP:INDEXK(r)
				return r - self.BITRK
			end
			luaP.MAXINDEXRK = luaP.BITRK - 1
			function luaP:RKASK(x)
				return x + self.BITRK
			end
			luaP.NO_REG = luaP.MAXARG_A
			luaP.opnames = {}
			luaP.OpCode = {}
			luaP.ROpCode = {}
			local i = 0
			for v in
				string.gmatch(
					[[
            	MOVE LOADK LOADBOOL LOADNIL GETUPVAL
            	GETGLOBAL GETTABLE SETGLOBAL SETUPVAL SETTABLE
            	NEWTABLE SELF ADD SUB MUL
            	DIV MOD POW UNM NOT
            	LEN CONCAT JMP EQ LT
            	LE TEST TESTSET CALL TAILCALL
            	RETURN FORLOOP FORPREP TFORLOOP SETLIST
            	CLOSE CLOSURE VARARG
            	]],
					"%S+"
				)
			do
				local n = "OP_" .. v
				luaP.opnames[i] = v
				luaP.OpCode[n] = i
				luaP.ROpCode[i] = n
				i = i + 1
			end
			luaP.NUM_OPCODES = i
			luaP.OpArgMask = {
				OpArgN = 0,
				OpArgU = 1,
				OpArgR = 2,
				OpArgK = 3,
			}
			function luaP:getOpMode(m)
				return self.opmodes[self.OpCode[m]] % 4
			end
			function luaP:getBMode(m)
				return math.floor(self.opmodes[self.OpCode[m]] / 16) % 4
			end
			function luaP:getCMode(m)
				return math.floor(self.opmodes[self.OpCode[m]] / 4) % 4
			end
			function luaP:testAMode(m)
				return math.floor(self.opmodes[self.OpCode[m]] / 64) % 2
			end
			function luaP:testTMode(m)
				return math.floor(self.opmodes[self.OpCode[m]] / 128)
			end
			luaP.LFIELDS_PER_FLUSH = 50
			local function opmode(t, a, b, c, m)
				local luaP = luaP
				return t * 128 + a * 64 + luaP.OpArgMask[b] * 16 + luaP.OpArgMask[c] * 4 + luaP.OpMode[m]
			end
			luaP.opmodes = {
				opmode(0, 1, "OpArgK", "OpArgN", "iABx"),
				opmode(0, 1, "OpArgU", "OpArgU", "iABC"),
				opmode(0, 1, "OpArgR", "OpArgN", "iABC"),
				opmode(0, 1, "OpArgU", "OpArgN", "iABC"),
				opmode(0, 1, "OpArgK", "OpArgN", "iABx"),
				opmode(0, 1, "OpArgR", "OpArgK", "iABC"),
				opmode(0, 0, "OpArgK", "OpArgN", "iABx"),
				opmode(0, 0, "OpArgU", "OpArgN", "iABC"),
				opmode(0, 0, "OpArgK", "OpArgK", "iABC"),
				opmode(0, 1, "OpArgU", "OpArgU", "iABC"),
				opmode(0, 1, "OpArgR", "OpArgK", "iABC"),
				opmode(0, 1, "OpArgK", "OpArgK", "iABC"),
				opmode(0, 1, "OpArgK", "OpArgK", "iABC"),
				opmode(0, 1, "OpArgK", "OpArgK", "iABC"),
				opmode(0, 1, "OpArgK", "OpArgK", "iABC"),
				opmode(0, 1, "OpArgK", "OpArgK", "iABC"),
				opmode(0, 1, "OpArgK", "OpArgK", "iABC"),
				opmode(0, 1, "OpArgR", "OpArgN", "iABC"),
				opmode(0, 1, "OpArgR", "OpArgN", "iABC"),
				opmode(0, 1, "OpArgR", "OpArgN", "iABC"),
				opmode(0, 1, "OpArgR", "OpArgR", "iABC"),
				opmode(0, 0, "OpArgR", "OpArgN", "iAsBx"),
				opmode(1, 0, "OpArgK", "OpArgK", "iABC"),
				opmode(1, 0, "OpArgK", "OpArgK", "iABC"),
				opmode(1, 0, "OpArgK", "OpArgK", "iABC"),
				opmode(1, 1, "OpArgR", "OpArgU", "iABC"),
				opmode(1, 1, "OpArgR", "OpArgU", "iABC"),
				opmode(0, 1, "OpArgU", "OpArgU", "iABC"),
				opmode(0, 1, "OpArgU", "OpArgU", "iABC"),
				opmode(0, 0, "OpArgU", "OpArgN", "iABC"),
				opmode(0, 1, "OpArgR", "OpArgN", "iAsBx"),
				opmode(0, 1, "OpArgR", "OpArgN", "iAsBx"),
				opmode(1, 0, "OpArgN", "OpArgU", "iABC"),
				opmode(0, 0, "OpArgU", "OpArgU", "iABC"),
				opmode(0, 0, "OpArgN", "OpArgN", "iABC"),
				opmode(0, 1, "OpArgU", "OpArgN", "iABx"),
				opmode(0, 1, "OpArgU", "OpArgN", "iABC"),
			}
			luaP.opmodes[0] = opmode(0, 1, "OpArgR", "OpArgN", "iABC")
			luaU.LUA_SIGNATURE = "\27Lua"
			luaU.LUA_TNUMBER = 3
			luaU.LUA_TSTRING = 4
			luaU.LUA_TNIL = 0
			luaU.LUA_TBOOLEAN = 1
			luaU.LUA_TNONE = -1
			luaU.LUAC_VERSION = 81
			luaU.LUAC_FORMAT = 0
			luaU.LUAC_HEADERSIZE = 12
			function luaU:make_setS()
				local buff = {}
				buff.data = ""
				local writer = function(s, buff)
					if not s then
						return 0
					end
					buff.data = buff.data .. s
					return 0
				end
				return writer, buff
			end
			function luaU:make_setF(filename)
				local buff = {}
				buff.h = io.open(filename, "wb")
				if not buff.h then
					return nil
				end
				local writer = function(s, buff)
					if not buff.h then
						return 0
					end
					if not s then
						if buff.h:close() then
							return 0
						end
					else
						if buff.h:write(s) then
							return 0
						end
					end
					return 1
				end
				return writer, buff
			end
			function luaU:ttype(o)
				local tt = type(o.value)
				if tt == "number" then
					return self.LUA_TNUMBER
				elseif tt == "string" then
					return self.LUA_TSTRING
				elseif tt == "nil" then
					return self.LUA_TNIL
				elseif tt == "boolean" then
					return self.LUA_TBOOLEAN
				else
					return self.LUA_TNONE
				end
			end
			function luaU:from_double(x)
				local function grab_byte(v)
					local c = v % 256
					return (v - c) / 256, string.char(c)
				end
				local sign = 0
				if x < 0 then
					sign = 1
					x = -x
				end
				local mantissa, exponent = math.frexp(x)
				if x == 0 then
					mantissa, exponent = 0, 0
				elseif x == 1 / 0 then
					mantissa, exponent = 0, 2047
				else
					mantissa = (mantissa * 2 - 1) * math.ldexp(0.5, 53)
					exponent = exponent + 1022
				end
				local v = ""
				local byte
				x = math.floor(mantissa)
				for i = 1, 6 do
					x, byte = grab_byte(x)
					v = v .. byte
				end
				x, byte = grab_byte(exponent * 16 + x)
				v = v .. byte
				x, byte = grab_byte(sign * 128 + x)
				v = v .. byte
				return v
			end
			function luaU:from_int(x)
				local v = ""
				x = math.floor(x)
				if x < 0 then
					x = 4294967296 + x
				end
				for i = 1, 4 do
					local c = x % 256
					v = v .. string.char(c)
					x = math.floor(x / 256)
				end
				return v
			end
			function luaU:DumpBlock(b, D)
				if D.status == 0 then
					D.status = D.write(b, D.data)
				end
			end
			function luaU:DumpChar(y, D)
				self:DumpBlock(string.char(y), D)
			end
			function luaU:DumpInt(x, D)
				self:DumpBlock(self:from_int(x), D)
			end
			function luaU:DumpSizeT(x, D)
				self:DumpBlock(self:from_int(x), D)
				if size_size_t == 8 then
					self:DumpBlock(self:from_int(0), D)
				end
			end
			function luaU:DumpNumber(x, D)
				self:DumpBlock(self:from_double(x), D)
			end
			function luaU:DumpString(s, D)
				if s == nil then
					self:DumpSizeT(0, D)
				else
					s = s .. "\0"
					self:DumpSizeT(#s, D)
					self:DumpBlock(s, D)
				end
			end
			function luaU:DumpCode(f, D)
				local n = f.sizecode
				self:DumpInt(n, D)
				for i = 0, n - 1 do
					self:DumpBlock(luaP:Instruction(f.code[i]), D)
				end
			end
			function luaU:DumpConstants(f, D)
				local n = f.sizek
				self:DumpInt(n, D)
				for i = 0, n - 1 do
					local o = f.k[i]
					local tt = self:ttype(o)
					self:DumpChar(tt, D)
					if tt == self.LUA_TNIL then
					elseif tt == self.LUA_TBOOLEAN then
						self:DumpChar(o.value and 1 or 0, D)
					elseif tt == self.LUA_TNUMBER then
						self:DumpNumber(o.value, D)
					elseif tt == self.LUA_TSTRING then
						self:DumpString(o.value, D)
					else
					end
				end
				n = f.sizep
				self:DumpInt(n, D)
				for i = 0, n - 1 do
					self:DumpFunction(f.p[i], f.source, D)
				end
			end
			function luaU:DumpDebug(f, D)
				local n
				n = D.strip and 0 or f.sizelineinfo
				self:DumpInt(n, D)
				for i = 0, n - 1 do
					self:DumpInt(f.lineinfo[i], D)
				end
				n = D.strip and 0 or f.sizelocvars
				self:DumpInt(n, D)
				for i = 0, n - 1 do
					self:DumpString(f.locvars[i].varname, D)
					self:DumpInt(f.locvars[i].startpc, D)
					self:DumpInt(f.locvars[i].endpc, D)
				end
				n = D.strip and 0 or f.sizeupvalues
				self:DumpInt(n, D)
				for i = 0, n - 1 do
					self:DumpString(f.upvalues[i], D)
				end
			end
			function luaU:DumpFunction(f, p, D)
				local source = f.source
				if source == p or D.strip then
					source = nil
				end
				self:DumpString(source, D)
				self:DumpInt(f.lineDefined, D)
				self:DumpInt(f.lastlinedefined, D)
				self:DumpChar(f.nups, D)
				self:DumpChar(f.numparams, D)
				self:DumpChar(f.is_vararg, D)
				self:DumpChar(f.maxstacksize, D)
				self:DumpCode(f, D)
				self:DumpConstants(f, D)
				self:DumpDebug(f, D)
			end
			function luaU:DumpHeader(D)
				local h = self:header()
				assert(#h == self.LUAC_HEADERSIZE)
				self:DumpBlock(h, D)
			end
			function luaU:header()
				local x = 1
				return self.LUA_SIGNATURE
					.. string.char(self.LUAC_VERSION, self.LUAC_FORMAT, x, 4, size_size_t, 4, 8, 0)
			end
			function luaU:dump(L, f, w, data, strip)
				local D = {}
				D.L = L
				D.write = w
				D.data = data
				D.strip = strip
				D.status = 0
				self:DumpHeader(D)
				self:DumpFunction(f, nil, D)
				D.write(nil, D.data)
				return D.status
			end
			luaK.MAXSTACK = 250
			function luaK:ttisnumber(o)
				if o then
					return type(o.value) == "number"
				else
					return false
				end
			end
			function luaK:nvalue(o)
				return o.value
			end
			function luaK:setnilvalue(o)
				o.value = nil
			end
			function luaK:setsvalue(o, x)
				o.value = x
			end
			luaK.setnvalue = luaK.setsvalue
			luaK.sethvalue = luaK.setsvalue
			luaK.setbvalue = luaK.setsvalue
			function luaK:numadd(a, b)
				return a + b
			end
			function luaK:numsub(a, b)
				return a - b
			end
			function luaK:nummul(a, b)
				return a * b
			end
			function luaK:numdiv(a, b)
				return a / b
			end
			function luaK:nummod(a, b)
				return a % b
			end
			function luaK:numpow(a, b)
				return a ^ b
			end
			function luaK:numunm(a)
				return -a
			end
			function luaK:numisnan(a)
				return not a == a
			end
			luaK.NO_JUMP = -1
			luaK.BinOpr = {
				OPR_ADD = 0,
				OPR_SUB = 1,
				OPR_MUL = 2,
				OPR_DIV = 3,
				OPR_MOD = 4,
				OPR_POW = 5,
				OPR_CONCAT = 6,
				OPR_NE = 7,
				OPR_EQ = 8,
				OPR_LT = 9,
				OPR_LE = 10,
				OPR_GT = 11,
				OPR_GE = 12,
				OPR_AND = 13,
				OPR_OR = 14,
				OPR_NOBINOPR = 15,
			}
			luaK.UnOpr = {
				OPR_MINUS = 0,
				OPR_NOT = 1,
				OPR_LEN = 2,
				OPR_NOUNOPR = 3,
			}
			function luaK:getcode(fs, e)
				return fs.f.code[e.info]
			end
			function luaK:codeAsBx(fs, o, A, sBx)
				return self:codeABx(fs, o, A, sBx + luaP.MAXARG_sBx)
			end
			function luaK:setmultret(fs, e)
				self:setreturns(fs, e, luaY.LUA_MULTRET)
			end
			function luaK:hasjumps(e)
				return e.t ~= e.f
			end
			function luaK:isnumeral(e)
				return e.k == "VKNUM" and e.t == self.NO_JUMP and e.f == self.NO_JUMP
			end
			function luaK:_nil(fs, from, n)
				if fs.pc > fs.lasttarget then
					if fs.pc == 0 then
						if from >= fs.nactvar then
							return
						end
					else
						local previous = fs.f.code[fs.pc - 1]
						if luaP:GET_OPCODE(previous) == "OP_LOADNIL" then
							local pfrom = luaP:GETARG_A(previous)
							local pto = luaP:GETARG_B(previous)
							if pfrom <= from and from <= pto + 1 then
								if from + n - 1 > pto then
									luaP:SETARG_B(previous, from + n - 1)
								end
								return
							end
						end
					end
				end
				self:codeABC(fs, "OP_LOADNIL", from, from + n - 1, 0)
			end
			function luaK:jump(fs)
				local jpc = fs.jpc
				fs.jpc = self.NO_JUMP
				local j = self:codeAsBx(fs, "OP_JMP", 0, self.NO_JUMP)
				j = self:concat(fs, j, jpc)
				return j
			end
			function luaK:ret(fs, first, nret)
				self:codeABC(fs, "OP_RETURN", first, nret + 1, 0)
			end
			function luaK:condjump(fs, op, A, B, C)
				self:codeABC(fs, op, A, B, C)
				return self:jump(fs)
			end
			function luaK:fixjump(fs, pc, dest)
				local jmp = fs.f.code[pc]
				local offset = dest - (pc + 1)
				lua_assert(dest ~= self.NO_JUMP)
				if math.abs(offset) > luaP.MAXARG_sBx then
					luaX:syntaxerror(fs.ls, "control structure too long")
				end
				luaP:SETARG_sBx(jmp, offset)
			end
			function luaK:getlabel(fs)
				fs.lasttarget = fs.pc
				return fs.pc
			end
			function luaK:getjump(fs, pc)
				local offset = luaP:GETARG_sBx(fs.f.code[pc])
				if offset == self.NO_JUMP then
					return self.NO_JUMP
				else
					return (pc + 1) + offset
				end
			end
			function luaK:getjumpcontrol(fs, pc)
				local pi = fs.f.code[pc]
				local ppi = fs.f.code[pc - 1]
				if pc >= 1 and luaP:testTMode(luaP:GET_OPCODE(ppi)) ~= 0 then
					return ppi
				else
					return pi
				end
			end
			function luaK:need_value(fs, list)
				while list ~= self.NO_JUMP do
					local i = self:getjumpcontrol(fs, list)
					if luaP:GET_OPCODE(i) ~= "OP_TESTSET" then
						return true
					end
					list = self:getjump(fs, list)
				end
				return false
			end
			function luaK:patchtestreg(fs, node, reg)
				local i = self:getjumpcontrol(fs, node)
				if luaP:GET_OPCODE(i) ~= "OP_TESTSET" then
					return false
				end
				if reg ~= luaP.NO_REG and reg ~= luaP:GETARG_B(i) then
					luaP:SETARG_A(i, reg)
				else
					luaP:SET_OPCODE(i, "OP_TEST")
					local b = luaP:GETARG_B(i)
					luaP:SETARG_A(i, b)
					luaP:SETARG_B(i, 0)
				end
				return true
			end
			function luaK:removevalues(fs, list)
				while list ~= self.NO_JUMP do
					self:patchtestreg(fs, list, luaP.NO_REG)
					list = self:getjump(fs, list)
				end
			end
			function luaK:patchlistaux(fs, list, vtarget, reg, dtarget)
				while list ~= self.NO_JUMP do
					local _next = self:getjump(fs, list)
					if self:patchtestreg(fs, list, reg) then
						self:fixjump(fs, list, vtarget)
					else
						self:fixjump(fs, list, dtarget)
					end
					list = _next
				end
			end
			function luaK:dischargejpc(fs)
				self:patchlistaux(fs, fs.jpc, fs.pc, luaP.NO_REG, fs.pc)
				fs.jpc = self.NO_JUMP
			end
			function luaK:patchlist(fs, list, target)
				if target == fs.pc then
					self:patchtohere(fs, list)
				else
					lua_assert(target < fs.pc)
					self:patchlistaux(fs, list, target, luaP.NO_REG, target)
				end
			end
			function luaK:patchtohere(fs, list)
				self:getlabel(fs)
				fs.jpc = self:concat(fs, fs.jpc, list)
			end
			function luaK:concat(fs, l1, l2)
				if l2 == self.NO_JUMP then
					return l1
				elseif l1 == self.NO_JUMP then
					return l2
				else
					local list = l1
					local _next = self:getjump(fs, list)
					while _next ~= self.NO_JUMP do
						list = _next
						_next = self:getjump(fs, list)
					end
					self:fixjump(fs, list, l2)
				end
				return l1
			end
			function luaK:checkstack(fs, n)
				local newstack = fs.freereg + n
				if newstack > fs.f.maxstacksize then
					if newstack >= self.MAXSTACK then
						luaX:syntaxerror(fs.ls, "function or expression too complex")
					end
					fs.f.maxstacksize = newstack
				end
			end
			function luaK:reserveregs(fs, n)
				self:checkstack(fs, n)
				fs.freereg = fs.freereg + n
			end
			function luaK:freereg(fs, reg)
				if not luaP:ISK(reg) and reg >= fs.nactvar then
					fs.freereg = fs.freereg - 1
					lua_assert(reg == fs.freereg)
				end
			end
			function luaK:freeexp(fs, e)
				if e.k == "VNONRELOC" then
					self:freereg(fs, e.info)
				end
			end
			function luaK:addk(fs, k, v)
				local L = fs.L
				local idx = fs.h[k.value]
				local f = fs.f
				if self:ttisnumber(idx) then
					return self:nvalue(idx)
				else
					idx = {}
					self:setnvalue(idx, fs.nk)
					fs.h[k.value] = idx
					luaY:growvector(L, f.k, fs.nk, f.sizek, nil, luaP.MAXARG_Bx, "constant table overflow")
					f.k[fs.nk] = v
					local nk = fs.nk
					fs.nk = fs.nk + 1
					return nk
				end
			end
			function luaK:stringK(fs, s)
				local o = {}
				self:setsvalue(o, s)
				return self:addk(fs, o, o)
			end
			function luaK:numberK(fs, r)
				local o = {}
				self:setnvalue(o, r)
				return self:addk(fs, o, o)
			end
			function luaK:boolK(fs, b)
				local o = {}
				self:setbvalue(o, b)
				return self:addk(fs, o, o)
			end
			function luaK:nilK(fs)
				local k, v = {}, {}
				self:setnilvalue(v)
				self:sethvalue(k, fs.h)
				return self:addk(fs, k, v)
			end
			function luaK:setreturns(fs, e, nresults)
				if e.k == "VCALL" then
					luaP:SETARG_C(self:getcode(fs, e), nresults + 1)
				elseif e.k == "VVARARG" then
					luaP:SETARG_B(self:getcode(fs, e), nresults + 1)
					luaP:SETARG_A(self:getcode(fs, e), fs.freereg)
					luaK:reserveregs(fs, 1)
				end
			end
			function luaK:setoneret(fs, e)
				if e.k == "VCALL" then
					e.k = "VNONRELOC"
					e.info = luaP:GETARG_A(self:getcode(fs, e))
				elseif e.k == "VVARARG" then
					luaP:SETARG_B(self:getcode(fs, e), 2)
					e.k = "VRELOCABLE"
				end
			end
			function luaK:dischargevars(fs, e)
				local k = e.k
				if k == "VLOCAL" then
					e.k = "VNONRELOC"
				elseif k == "VUPVAL" then
					e.info = self:codeABC(fs, "OP_GETUPVAL", 0, e.info, 0)
					e.k = "VRELOCABLE"
				elseif k == "VGLOBAL" then
					e.info = self:codeABx(fs, "OP_GETGLOBAL", 0, e.info)
					e.k = "VRELOCABLE"
				elseif k == "VINDEXED" then
					self:freereg(fs, e.aux)
					self:freereg(fs, e.info)
					e.info = self:codeABC(fs, "OP_GETTABLE", 0, e.info, e.aux)
					e.k = "VRELOCABLE"
				elseif k == "VVARARG" or k == "VCALL" then
					self:setoneret(fs, e)
				else
				end
			end
			function luaK:code_label(fs, A, b, jump)
				self:getlabel(fs)
				return self:codeABC(fs, "OP_LOADBOOL", A, b, jump)
			end
			function luaK:discharge2reg(fs, e, reg)
				self:dischargevars(fs, e)
				local k = e.k
				if k == "VNIL" then
					self:_nil(fs, reg, 1)
				elseif k == "VFALSE" or k == "VTRUE" then
					self:codeABC(fs, "OP_LOADBOOL", reg, (e.k == "VTRUE") and 1 or 0, 0)
				elseif k == "VK" then
					self:codeABx(fs, "OP_LOADK", reg, e.info)
				elseif k == "VKNUM" then
					self:codeABx(fs, "OP_LOADK", reg, self:numberK(fs, e.nval))
				elseif k == "VRELOCABLE" then
					local pc = self:getcode(fs, e)
					luaP:SETARG_A(pc, reg)
				elseif k == "VNONRELOC" then
					if reg ~= e.info then
						self:codeABC(fs, "OP_MOVE", reg, e.info, 0)
					end
				else
					lua_assert(e.k == "VVOID" or e.k == "VJMP")
					return
				end
				e.info = reg
				e.k = "VNONRELOC"
			end
			function luaK:discharge2anyreg(fs, e)
				if e.k ~= "VNONRELOC" then
					self:reserveregs(fs, 1)
					self:discharge2reg(fs, e, fs.freereg - 1)
				end
			end
			function luaK:exp2reg(fs, e, reg)
				self:discharge2reg(fs, e, reg)
				if e.k == "VJMP" then
					e.t = self:concat(fs, e.t, e.info)
				end
				if self:hasjumps(e) then
					local final
					local p_f = self.NO_JUMP
					local p_t = self.NO_JUMP
					if self:need_value(fs, e.t) or self:need_value(fs, e.f) then
						local fj = (e.k == "VJMP") and self.NO_JUMP or self:jump(fs)
						p_f = self:code_label(fs, reg, 0, 1)
						p_t = self:code_label(fs, reg, 1, 0)
						self:patchtohere(fs, fj)
					end
					final = self:getlabel(fs)
					self:patchlistaux(fs, e.f, final, reg, p_f)
					self:patchlistaux(fs, e.t, final, reg, p_t)
				end
				e.f, e.t = self.NO_JUMP, self.NO_JUMP
				e.info = reg
				e.k = "VNONRELOC"
			end
			function luaK:exp2nextreg(fs, e)
				self:dischargevars(fs, e)
				self:freeexp(fs, e)
				self:reserveregs(fs, 1)
				self:exp2reg(fs, e, fs.freereg - 1)
			end
			function luaK:exp2anyreg(fs, e)
				self:dischargevars(fs, e)
				if e.k == "VNONRELOC" then
					if not self:hasjumps(e) then
						return e.info
					end
					if e.info >= fs.nactvar then
						self:exp2reg(fs, e, e.info)
						return e.info
					end
				end
				self:exp2nextreg(fs, e)
				return e.info
			end
			function luaK:exp2val(fs, e)
				if self:hasjumps(e) then
					self:exp2anyreg(fs, e)
				else
					self:dischargevars(fs, e)
				end
			end
			function luaK:exp2RK(fs, e)
				self:exp2val(fs, e)
				local k = e.k
				if k == "VKNUM" or k == "VTRUE" or k == "VFALSE" or k == "VNIL" then
					if fs.nk <= luaP.MAXINDEXRK then
						if e.k == "VNIL" then
							e.info = self:nilK(fs)
						else
							e.info = (e.k == "VKNUM") and self:numberK(fs, e.nval) or self:boolK(fs, e.k == "VTRUE")
						end
						e.k = "VK"
						return luaP:RKASK(e.info)
					end
				elseif k == "VK" then
					if e.info <= luaP.MAXINDEXRK then
						return luaP:RKASK(e.info)
					end
				else
				end
				return self:exp2anyreg(fs, e)
			end
			function luaK:storevar(fs, var, ex)
				local k = var.k
				if k == "VLOCAL" then
					self:freeexp(fs, ex)
					self:exp2reg(fs, ex, var.info)
					return
				elseif k == "VUPVAL" then
					local e = self:exp2anyreg(fs, ex)
					self:codeABC(fs, "OP_SETUPVAL", e, var.info, 0)
				elseif k == "VGLOBAL" then
					local e = self:exp2anyreg(fs, ex)
					self:codeABx(fs, "OP_SETGLOBAL", e, var.info)
				elseif k == "VINDEXED" then
					local e = self:exp2RK(fs, ex)
					self:codeABC(fs, "OP_SETTABLE", var.info, var.aux, e)
				else
					lua_assert(0)
				end
				self:freeexp(fs, ex)
			end
			function luaK:_self(fs, e, key)
				self:exp2anyreg(fs, e)
				self:freeexp(fs, e)
				local func = fs.freereg
				self:reserveregs(fs, 2)
				self:codeABC(fs, "OP_SELF", func, e.info, self:exp2RK(fs, key))
				self:freeexp(fs, key)
				e.info = func
				e.k = "VNONRELOC"
			end
			function luaK:invertjump(fs, e)
				local pc = self:getjumpcontrol(fs, e.info)
				lua_assert(
					luaP:testTMode(luaP:GET_OPCODE(pc)) ~= 0
						and luaP:GET_OPCODE(pc) ~= "OP_TESTSET"
						and luaP:GET_OPCODE(pc) ~= "OP_TEST"
				)
				luaP:SETARG_A(pc, (luaP:GETARG_A(pc) == 0) and 1 or 0)
			end
			function luaK:jumponcond(fs, e, cond)
				if e.k == "VRELOCABLE" then
					local ie = self:getcode(fs, e)
					if luaP:GET_OPCODE(ie) == "OP_NOT" then
						fs.pc = fs.pc - 1
						return self:condjump(fs, "OP_TEST", luaP:GETARG_B(ie), 0, cond and 0 or 1)
					end
				end
				self:discharge2anyreg(fs, e)
				self:freeexp(fs, e)
				return self:condjump(fs, "OP_TESTSET", luaP.NO_REG, e.info, cond and 1 or 0)
			end
			function luaK:goiftrue(fs, e)
				local pc
				self:dischargevars(fs, e)
				local k = e.k
				if k == "VK" or k == "VKNUM" or k == "VTRUE" then
					pc = self.NO_JUMP
				elseif k == "VFALSE" then
					pc = self:jump(fs)
				elseif k == "VJMP" then
					self:invertjump(fs, e)
					pc = e.info
				else
					pc = self:jumponcond(fs, e, false)
				end
				e.f = self:concat(fs, e.f, pc)
				self:patchtohere(fs, e.t)
				e.t = self.NO_JUMP
			end
			function luaK:goiffalse(fs, e)
				local pc
				self:dischargevars(fs, e)
				local k = e.k
				if k == "VNIL" or k == "VFALSE" then
					pc = self.NO_JUMP
				elseif k == "VTRUE" then
					pc = self:jump(fs)
				elseif k == "VJMP" then
					pc = e.info
				else
					pc = self:jumponcond(fs, e, true)
				end
				e.t = self:concat(fs, e.t, pc)
				self:patchtohere(fs, e.f)
				e.f = self.NO_JUMP
			end
			function luaK:codenot(fs, e)
				self:dischargevars(fs, e)
				local k = e.k
				if k == "VNIL" or k == "VFALSE" then
					e.k = "VTRUE"
				elseif k == "VK" or k == "VKNUM" or k == "VTRUE" then
					e.k = "VFALSE"
				elseif k == "VJMP" then
					self:invertjump(fs, e)
				elseif k == "VRELOCABLE" or k == "VNONRELOC" then
					self:discharge2anyreg(fs, e)
					self:freeexp(fs, e)
					e.info = self:codeABC(fs, "OP_NOT", 0, e.info, 0)
					e.k = "VRELOCABLE"
				else
					lua_assert(0)
				end
				e.f, e.t = e.t, e.f
				self:removevalues(fs, e.f)
				self:removevalues(fs, e.t)
			end
			function luaK:indexed(fs, t, k)
				t.aux = self:exp2RK(fs, k)
				t.k = "VINDEXED"
			end
			function luaK:constfolding(op, e1, e2)
				local r
				if not self:isnumeral(e1) or not self:isnumeral(e2) then
					return false
				end
				local v1 = e1.nval
				local v2 = e2.nval
				if op == "OP_ADD" then
					r = self:numadd(v1, v2)
				elseif op == "OP_SUB" then
					r = self:numsub(v1, v2)
				elseif op == "OP_MUL" then
					r = self:nummul(v1, v2)
				elseif op == "OP_DIV" then
					if v2 == 0 then
						return false
					end
					r = self:numdiv(v1, v2)
				elseif op == "OP_MOD" then
					if v2 == 0 then
						return false
					end
					r = self:nummod(v1, v2)
				elseif op == "OP_POW" then
					r = self:numpow(v1, v2)
				elseif op == "OP_UNM" then
					r = self:numunm(v1)
				elseif op == "OP_LEN" then
					return false
				else
					lua_assert(0)
					r = 0
				end
				if self:numisnan(r) then
					return false
				end
				e1.nval = r
				return true
			end
			function luaK:codearith(fs, op, e1, e2)
				if self:constfolding(op, e1, e2) then
					return
				else
					local o2 = (op ~= "OP_UNM" and op ~= "OP_LEN") and self:exp2RK(fs, e2) or 0
					local o1 = self:exp2RK(fs, e1)
					if o1 > o2 then
						self:freeexp(fs, e1)
						self:freeexp(fs, e2)
					else
						self:freeexp(fs, e2)
						self:freeexp(fs, e1)
					end
					e1.info = self:codeABC(fs, op, 0, o1, o2)
					e1.k = "VRELOCABLE"
				end
			end
			function luaK:codecomp(fs, op, cond, e1, e2)
				local o1 = self:exp2RK(fs, e1)
				local o2 = self:exp2RK(fs, e2)
				self:freeexp(fs, e2)
				self:freeexp(fs, e1)
				if cond == 0 and op ~= "OP_EQ" then
					o1, o2 = o2, o1
					cond = 1
				end
				e1.info = self:condjump(fs, op, cond, o1, o2)
				e1.k = "VJMP"
			end
			function luaK:prefix(fs, op, e)
				local e2 = {}
				e2.t, e2.f = self.NO_JUMP, self.NO_JUMP
				e2.k = "VKNUM"
				e2.nval = 0
				if op == "OPR_MINUS" then
					if not self:isnumeral(e) then
						self:exp2anyreg(fs, e)
					end
					self:codearith(fs, "OP_UNM", e, e2)
				elseif op == "OPR_NOT" then
					self:codenot(fs, e)
				elseif op == "OPR_LEN" then
					self:exp2anyreg(fs, e)
					self:codearith(fs, "OP_LEN", e, e2)
				else
					lua_assert(0)
				end
			end
			function luaK:infix(fs, op, v)
				if op == "OPR_AND" then
					self:goiftrue(fs, v)
				elseif op == "OPR_OR" then
					self:goiffalse(fs, v)
				elseif op == "OPR_CONCAT" then
					self:exp2nextreg(fs, v)
				elseif
					op == "OPR_ADD"
					or op == "OPR_SUB"
					or op == "OPR_MUL"
					or op == "OPR_DIV"
					or op == "OPR_MOD"
					or op == "OPR_POW"
				then
					if not self:isnumeral(v) then
						self:exp2RK(fs, v)
					end
				else
					self:exp2RK(fs, v)
				end
			end
			luaK.arith_op = {
				OPR_ADD = "OP_ADD",
				OPR_SUB = "OP_SUB",
				OPR_MUL = "OP_MUL",
				OPR_DIV = "OP_DIV",
				OPR_MOD = "OP_MOD",
				OPR_POW = "OP_POW",
			}
			luaK.comp_op = {
				OPR_EQ = "OP_EQ",
				OPR_NE = "OP_EQ",
				OPR_LT = "OP_LT",
				OPR_LE = "OP_LE",
				OPR_GT = "OP_LT",
				OPR_GE = "OP_LE",
			}
			luaK.comp_cond = {
				OPR_EQ = 1,
				OPR_NE = 0,
				OPR_LT = 1,
				OPR_LE = 1,
				OPR_GT = 0,
				OPR_GE = 0,
			}
			function luaK:posfix(fs, op, e1, e2)
				local function copyexp(e1, e2)
					e1.k = e2.k
					e1.info = e2.info
					e1.aux = e2.aux
					e1.nval = e2.nval
					e1.t = e2.t
					e1.f = e2.f
				end
				if op == "OPR_AND" then
					lua_assert(e1.t == self.NO_JUMP)
					self:dischargevars(fs, e2)
					e2.f = self:concat(fs, e2.f, e1.f)
					copyexp(e1, e2)
				elseif op == "OPR_OR" then
					lua_assert(e1.f == self.NO_JUMP)
					self:dischargevars(fs, e2)
					e2.t = self:concat(fs, e2.t, e1.t)
					copyexp(e1, e2)
				elseif op == "OPR_CONCAT" then
					self:exp2val(fs, e2)
					if e2.k == "VRELOCABLE" and luaP:GET_OPCODE(self:getcode(fs, e2)) == "OP_CONCAT" then
						lua_assert(e1.info == luaP:GETARG_B(self:getcode(fs, e2)) - 1)
						self:freeexp(fs, e1)
						luaP:SETARG_B(self:getcode(fs, e2), e1.info)
						e1.k = "VRELOCABLE"
						e1.info = e2.info
					else
						self:exp2nextreg(fs, e2)
						self:codearith(fs, "OP_CONCAT", e1, e2)
					end
				else
					local arith = self.arith_op[op]
					if arith then
						self:codearith(fs, arith, e1, e2)
					else
						local comp = self.comp_op[op]
						if comp then
							self:codecomp(fs, comp, self.comp_cond[op], e1, e2)
						else
							lua_assert(0)
						end
					end
				end
			end
			function luaK:fixline(fs, line)
				fs.f.lineinfo[fs.pc - 1] = line
			end
			function luaK:code(fs, i, line)
				local f = fs.f
				self:dischargejpc(fs)
				luaY:growvector(fs.L, f.code, fs.pc, f.sizecode, nil, luaY.MAX_INT, "code size overflow")
				f.code[fs.pc] = i
				luaY:growvector(fs.L, f.lineinfo, fs.pc, f.sizelineinfo, nil, luaY.MAX_INT, "code size overflow")
				f.lineinfo[fs.pc] = line
				local pc = fs.pc
				fs.pc = fs.pc + 1
				return pc
			end
			function luaK:codeABC(fs, o, a, b, c)
				lua_assert(luaP:getOpMode(o) == luaP.OpMode.iABC)
				lua_assert(luaP:getBMode(o) ~= luaP.OpArgMask.OpArgN or b == 0)
				lua_assert(luaP:getCMode(o) ~= luaP.OpArgMask.OpArgN or c == 0)
				return self:code(fs, luaP:CREATE_ABC(o, a, b, c), fs.ls.lastline)
			end
			function luaK:codeABx(fs, o, a, bc)
				lua_assert(luaP:getOpMode(o) == luaP.OpMode.iABx or luaP:getOpMode(o) == luaP.OpMode.iAsBx)
				lua_assert(luaP:getCMode(o) == luaP.OpArgMask.OpArgN)
				return self:code(fs, luaP:CREATE_ABx(o, a, bc), fs.ls.lastline)
			end
			function luaK:setlist(fs, base, nelems, tostore)
				local c = math.floor((nelems - 1) / luaP.LFIELDS_PER_FLUSH) + 1
				local b = (tostore == luaY.LUA_MULTRET) and 0 or tostore
				lua_assert(tostore ~= 0)
				if c <= luaP.MAXARG_C then
					self:codeABC(fs, "OP_SETLIST", base, b, c)
				else
					self:codeABC(fs, "OP_SETLIST", base, b, 0)
					self:code(fs, luaP:CREATE_Inst(c), fs.ls.lastline)
				end
				fs.freereg = base + 1
			end
			luaY.LUA_QS = luaX.LUA_QS or "'%s'"
			luaY.SHRT_MAX = 32767
			luaY.LUAI_MAXVARS = 200
			luaY.LUAI_MAXUPVALUES = 60
			luaY.MAX_INT = luaX.MAX_INT or 2147483645
			luaY.LUAI_MAXCCALLS = 200
			luaY.VARARG_HASARG = 1
			luaY.HASARG_MASK = 2
			luaY.VARARG_ISVARARG = 2
			luaY.VARARG_NEEDSARG = 4
			luaY.LUA_MULTRET = -1
			function luaY:LUA_QL(x)
				return "'" .. x .. "'"
			end
			function luaY:growvector(L, v, nelems, size, t, limit, e)
				if nelems >= limit then
					error(e)
				end
			end
			function luaY:newproto(L)
				local f = {}
				f.k = {}
				f.sizek = 0
				f.p = {}
				f.sizep = 0
				f.code = {}
				f.sizecode = 0
				f.sizelineinfo = 0
				f.sizeupvalues = 0
				f.nups = 0
				f.upvalues = {}
				f.numparams = 0
				f.is_vararg = 0
				f.maxstacksize = 0
				f.lineinfo = {}
				f.sizelocvars = 0
				f.locvars = {}
				f.lineDefined = 0
				f.lastlinedefined = 0
				f.source = nil
				return f
			end
			function luaY:int2fb(x)
				local e = 0
				while x >= 16 do
					x = math.floor((x + 1) / 2)
					e = e + 1
				end
				if x < 8 then
					return x
				else
					return ((e + 1) * 8) + (x - 8)
				end
			end
			function luaY:hasmultret(k)
				return k == "VCALL" or k == "VVARARG"
			end
			function luaY:getlocvar(fs, i)
				return fs.f.locvars[fs.actvar[i]]
			end
			function luaY:checklimit(fs, v, l, m)
				if v > l then
					self:errorlimit(fs, l, m)
				end
			end
			function luaY:anchor_token(ls)
				if ls.t.token == "TK_NAME" or ls.t.token == "TK_STRING" then
				end
			end
			function luaY:error_expected(ls, token)
				luaX:syntaxerror(ls, string.format(self.LUA_QS .. " expected", luaX:token2str(ls, token)))
			end
			function luaY:errorlimit(fs, limit, what)
				local msg = (fs.f.linedefined == 0) and string.format("main function has more than %d %s", limit, what)
					or string.format("function at line %d has more than %d %s", fs.f.linedefined, limit, what)
				luaX:lexerror(fs.ls, msg, 0)
			end
			function luaY:testnext(ls, c)
				if ls.t.token == c then
					luaX:next(ls)
					return true
				else
					return false
				end
			end
			function luaY:check(ls, c)
				if ls.t.token ~= c then
					self:error_expected(ls, c)
				end
			end
			function luaY:checknext(ls, c)
				self:check(ls, c)
				luaX:next(ls)
			end
			function luaY:check_condition(ls, c, msg)
				if not c then
					luaX:syntaxerror(ls, msg)
				end
			end
			function luaY:check_match(ls, what, who, where)
				if not self:testnext(ls, what) then
					if where == ls.linenumber then
						self:error_expected(ls, what)
					else
						luaX:syntaxerror(
							ls,
							string.format(
								self.LUA_QS .. " expected (to close " .. self.LUA_QS .. " at line %d)",
								luaX:token2str(ls, what),
								luaX:token2str(ls, who),
								where
							)
						)
					end
				end
			end
			function luaY:str_checkname(ls)
				self:check(ls, "TK_NAME")
				local ts = ls.t.seminfo
				luaX:next(ls)
				return ts
			end
			function luaY:init_exp(e, k, i)
				e.f, e.t = luaK.NO_JUMP, luaK.NO_JUMP
				e.k = k
				e.info = i
			end
			function luaY:codestring(ls, e, s)
				self:init_exp(e, "VK", luaK:stringK(ls.fs, s))
			end
			function luaY:checkname(ls, e)
				self:codestring(ls, e, self:str_checkname(ls))
			end
			function luaY:registerlocalvar(ls, varname)
				local fs = ls.fs
				local f = fs.f
				self:growvector(
					ls.L,
					f.locvars,
					fs.nlocvars,
					f.sizelocvars,
					nil,
					self.SHRT_MAX,
					"too many local variables"
				)
				f.locvars[fs.nlocvars] = {}
				f.locvars[fs.nlocvars].varname = varname
				local nlocvars = fs.nlocvars
				fs.nlocvars = fs.nlocvars + 1
				return nlocvars
			end
			function luaY:new_localvarliteral(ls, v, n)
				self:new_localvar(ls, v, n)
			end
			function luaY:new_localvar(ls, name, n)
				local fs = ls.fs
				self:checklimit(fs, fs.nactvar + n + 1, self.LUAI_MAXVARS, "local variables")
				fs.actvar[fs.nactvar + n] = self:registerlocalvar(ls, name)
			end
			function luaY:adjustlocalvars(ls, nvars)
				local fs = ls.fs
				fs.nactvar = fs.nactvar + nvars
				for i = nvars, 1, -1 do
					self:getlocvar(fs, fs.nactvar - i).startpc = fs.pc
				end
			end
			function luaY:removevars(ls, tolevel)
				local fs = ls.fs
				while fs.nactvar > tolevel do
					fs.nactvar = fs.nactvar - 1
					self:getlocvar(fs, fs.nactvar).endpc = fs.pc
				end
			end
			function luaY:indexupvalue(fs, name, v)
				local f = fs.f
				for i = 0, f.nups - 1 do
					if fs.upvalues[i].k == v.k and fs.upvalues[i].info == v.info then
						lua_assert(f.upvalues[i] == name)
						return i
					end
				end
				self:checklimit(fs, f.nups + 1, self.LUAI_MAXUPVALUES, "upvalues")
				self:growvector(fs.L, f.upvalues, f.nups, f.sizeupvalues, nil, self.MAX_INT, "")
				f.upvalues[f.nups] = name
				lua_assert(v.k == "VLOCAL" or v.k == "VUPVAL")
				fs.upvalues[f.nups] = {
					k = v.k,
					info = v.info,
				}
				local nups = f.nups
				f.nups = f.nups + 1
				return nups
			end
			function luaY:searchvar(fs, n)
				for i = fs.nactvar - 1, 0, -1 do
					if n == self:getlocvar(fs, i).varname then
						return i
					end
				end
				return -1
			end
			function luaY:markupval(fs, level)
				local bl = fs.bl
				while bl and bl.nactvar > level do
					bl = bl.previous
				end
				if bl then
					bl.upval = true
				end
			end
			function luaY:singlevaraux(fs, n, var, base)
				if fs == nil then
					self:init_exp(var, "VGLOBAL", luaP.NO_REG)
					return "VGLOBAL"
				else
					local v = self:searchvar(fs, n)
					if v >= 0 then
						self:init_exp(var, "VLOCAL", v)
						if base == 0 then
							self:markupval(fs, v)
						end
						return "VLOCAL"
					else
						if self:singlevaraux(fs.prev, n, var, 0) == "VGLOBAL" then
							return "VGLOBAL"
						end
						var.info = self:indexupvalue(fs, n, var)
						var.k = "VUPVAL"
						return "VUPVAL"
					end
				end
			end
			function luaY:singlevar(ls, var)
				local varname = self:str_checkname(ls)
				local fs = ls.fs
				if self:singlevaraux(fs, varname, var, 1) == "VGLOBAL" then
					var.info = luaK:stringK(fs, varname)
				end
			end
			function luaY:adjust_assign(ls, nvars, nexps, e)
				local fs = ls.fs
				local extra = nvars - nexps
				if self:hasmultret(e.k) then
					extra = extra + 1
					if extra <= 0 then
						extra = 0
					end
					luaK:setreturns(fs, e, extra)
					if extra > 1 then
						luaK:reserveregs(fs, extra - 1)
					end
				else
					if e.k ~= "VVOID" then
						luaK:exp2nextreg(fs, e)
					end
					if extra > 0 then
						local reg = fs.freereg
						luaK:reserveregs(fs, extra)
						luaK:_nil(fs, reg, extra)
					end
				end
			end
			function luaY:enterlevel(ls)
				ls.L.nCcalls = ls.L.nCcalls + 1
				if ls.L.nCcalls > self.LUAI_MAXCCALLS then
					luaX:lexerror(ls, "chunk has too many syntax levels", 0)
				end
			end
			function luaY:leavelevel(ls)
				ls.L.nCcalls = ls.L.nCcalls - 1
			end
			function luaY:enterblock(fs, bl, isbreakable)
				bl.breaklist = luaK.NO_JUMP
				bl.isbreakable = isbreakable
				bl.nactvar = fs.nactvar
				bl.upval = false
				bl.previous = fs.bl
				fs.bl = bl
				lua_assert(fs.freereg == fs.nactvar)
			end
			function luaY:leaveblock(fs)
				local bl = fs.bl
				fs.bl = bl.previous
				self:removevars(fs.ls, bl.nactvar)
				if bl.upval then
					luaK:codeABC(fs, "OP_CLOSE", bl.nactvar, 0, 0)
				end
				lua_assert(not bl.isbreakable or not bl.upval)
				lua_assert(bl.nactvar == fs.nactvar)
				fs.freereg = fs.nactvar
				luaK:patchtohere(fs, bl.breaklist)
			end
			function luaY:pushclosure(ls, func, v)
				local fs = ls.fs
				local f = fs.f
				self:growvector(ls.L, f.p, fs.np, f.sizep, nil, luaP.MAXARG_Bx, "constant table overflow")
				f.p[fs.np] = func.f
				fs.np = fs.np + 1
				self:init_exp(v, "VRELOCABLE", luaK:codeABx(fs, "OP_CLOSURE", 0, fs.np - 1))
				for i = 0, func.f.nups - 1 do
					local o = (func.upvalues[i].k == "VLOCAL") and "OP_MOVE" or "OP_GETUPVAL"
					luaK:codeABC(fs, o, 0, func.upvalues[i].info, 0)
				end
			end
			function luaY:open_func(ls, fs)
				local L = ls.L
				local f = self:newproto(ls.L)
				fs.f = f
				fs.prev = ls.fs
				fs.ls = ls
				fs.L = L
				ls.fs = fs
				fs.pc = 0
				fs.lasttarget = -1
				fs.jpc = luaK.NO_JUMP
				fs.freereg = 0
				fs.nk = 0
				fs.np = 0
				fs.nlocvars = 0
				fs.nactvar = 0
				fs.bl = nil
				f.source = ls.source
				f.maxstacksize = 2
				fs.h = {}
			end
			function luaY:close_func(ls)
				local L = ls.L
				local fs = ls.fs
				local f = fs.f
				self:removevars(ls, 0)
				luaK:ret(fs, 0, 0)
				f.sizecode = fs.pc
				f.sizelineinfo = fs.pc
				f.sizek = fs.nk
				f.sizep = fs.np
				f.sizelocvars = fs.nlocvars
				f.sizeupvalues = f.nups
				lua_assert(fs.bl == nil)
				ls.fs = fs.prev
				if fs then
					self:anchor_token(ls)
				end
			end
			function luaY:parser(L, z, buff, name)
				local lexstate = {}
				lexstate.t = {}
				lexstate.lookahead = {}
				local funcstate = {}
				funcstate.upvalues = {}
				funcstate.actvar = {}
				L.nCcalls = 0
				lexstate.buff = buff
				luaX:setinput(L, lexstate, z, name)
				self:open_func(lexstate, funcstate)
				funcstate.f.is_vararg = self.VARARG_ISVARARG
				luaX:next(lexstate)
				self:chunk(lexstate)
				self:check(lexstate, "TK_EOS")
				self:close_func(lexstate)
				lua_assert(funcstate.prev == nil)
				lua_assert(funcstate.f.nups == 0)
				lua_assert(lexstate.fs == nil)
				return funcstate.f
			end
			function luaY:field(ls, v)
				local fs = ls.fs
				local key = {}
				luaK:exp2anyreg(fs, v)
				luaX:next(ls)
				self:checkname(ls, key)
				luaK:indexed(fs, v, key)
			end
			function luaY:yindex(ls, v)
				luaX:next(ls)
				self:expr(ls, v)
				luaK:exp2val(ls.fs, v)
				self:checknext(ls, "]")
			end
			function luaY:recfield(ls, cc)
				local fs = ls.fs
				local reg = ls.fs.freereg
				local key, val = {}, {}
				if ls.t.token == "TK_NAME" then
					self:checklimit(fs, cc.nh, self.MAX_INT, "items in a constructor")
					self:checkname(ls, key)
				else
					self:yindex(ls, key)
				end
				cc.nh = cc.nh + 1
				self:checknext(ls, "=")
				local rkkey = luaK:exp2RK(fs, key)
				self:expr(ls, val)
				luaK:codeABC(fs, "OP_SETTABLE", cc.t.info, rkkey, luaK:exp2RK(fs, val))
				fs.freereg = reg
			end
			function luaY:closelistfield(fs, cc)
				if cc.v.k == "VVOID" then
					return
				end
				luaK:exp2nextreg(fs, cc.v)
				cc.v.k = "VVOID"
				if cc.tostore == luaP.LFIELDS_PER_FLUSH then
					luaK:setlist(fs, cc.t.info, cc.na, cc.tostore)
					cc.tostore = 0
				end
			end
			function luaY:lastlistfield(fs, cc)
				if cc.tostore == 0 then
					return
				end
				if self:hasmultret(cc.v.k) then
					luaK:setmultret(fs, cc.v)
					luaK:setlist(fs, cc.t.info, cc.na, self.LUA_MULTRET)
					cc.na = cc.na - 1
				else
					if cc.v.k ~= "VVOID" then
						luaK:exp2nextreg(fs, cc.v)
					end
					luaK:setlist(fs, cc.t.info, cc.na, cc.tostore)
				end
			end
			function luaY:listfield(ls, cc)
				self:expr(ls, cc.v)
				self:checklimit(ls.fs, cc.na, self.MAX_INT, "items in a constructor")
				cc.na = cc.na + 1
				cc.tostore = cc.tostore + 1
			end
			function luaY:constructor(ls, t)
				local fs = ls.fs
				local line = ls.linenumber
				local pc = luaK:codeABC(fs, "OP_NEWTABLE", 0, 0, 0)
				local cc = {}
				cc.v = {}
				cc.na, cc.nh, cc.tostore = 0, 0, 0
				cc.t = t
				self:init_exp(t, "VRELOCABLE", pc)
				self:init_exp(cc.v, "VVOID", 0)
				luaK:exp2nextreg(ls.fs, t)
				self:checknext(ls, "{")
				repeat
					lua_assert(cc.v.k == "VVOID" or cc.tostore > 0)
					if ls.t.token == "}" then
						break
					end
					self:closelistfield(fs, cc)
					local c = ls.t.token
					if c == "TK_NAME" then
						luaX:lookahead(ls)
						if ls.lookahead.token ~= "=" then
							self:listfield(ls, cc)
						else
							self:recfield(ls, cc)
						end
					elseif c == "[" then
						self:recfield(ls, cc)
					else
						self:listfield(ls, cc)
					end
				until not self:testnext(ls, ",") and not self:testnext(ls, ";")
				self:check_match(ls, "}", "{", line)
				self:lastlistfield(fs, cc)
				luaP:SETARG_B(fs.f.code[pc], self:int2fb(cc.na))
				luaP:SETARG_C(fs.f.code[pc], self:int2fb(cc.nh))
			end
			function luaY:parlist(ls)
				local fs = ls.fs
				local f = fs.f
				local nparams = 0
				f.is_vararg = 0
				if ls.t.token ~= ")" then
					repeat
						local c = ls.t.token
						if c == "TK_NAME" then
							self:new_localvar(ls, self:str_checkname(ls), nparams)
							nparams = nparams + 1
						elseif c == "TK_DOTS" then
							luaX:next(ls)
							self:new_localvarliteral(ls, "arg", nparams)
							nparams = nparams + 1
							f.is_vararg = self.VARARG_HASARG + self.VARARG_NEEDSARG
							f.is_vararg = f.is_vararg + self.VARARG_ISVARARG
						else
							luaX:syntaxerror(ls, "<name> or " .. self:LUA_QL("...") .. " expected")
						end
					until f.is_vararg ~= 0 or not self:testnext(ls, ",")
				end
				self:adjustlocalvars(ls, nparams)
				f.numparams = fs.nactvar - (f.is_vararg % self.HASARG_MASK)
				luaK:reserveregs(fs, fs.nactvar)
			end
			function luaY:body(ls, e, needself, line)
				local new_fs = {}
				new_fs.upvalues = {}
				new_fs.actvar = {}
				self:open_func(ls, new_fs)
				new_fs.f.lineDefined = line
				self:checknext(ls, "(")
				if needself then
					self:new_localvarliteral(ls, "self", 0)
					self:adjustlocalvars(ls, 1)
				end
				self:parlist(ls)
				self:checknext(ls, ")")
				self:chunk(ls)
				new_fs.f.lastlinedefined = ls.linenumber
				self:check_match(ls, "TK_END", "TK_FUNCTION", line)
				self:close_func(ls)
				self:pushclosure(ls, new_fs, e)
			end
			function luaY:explist1(ls, v)
				local n = 1
				self:expr(ls, v)
				while self:testnext(ls, ",") do
					luaK:exp2nextreg(ls.fs, v)
					self:expr(ls, v)
					n = n + 1
				end
				return n
			end
			function luaY:funcargs(ls, f)
				local fs = ls.fs
				local args = {}
				local nparams
				local line = ls.linenumber
				local c = ls.t.token
				if c == "(" then
					if line ~= ls.lastline then
						luaX:syntaxerror(ls, "ambiguous syntax (function call x new statement)")
					end
					luaX:next(ls)
					if ls.t.token == ")" then
						args.k = "VVOID"
					else
						self:explist1(ls, args)
						luaK:setmultret(fs, args)
					end
					self:check_match(ls, ")", "(", line)
				elseif c == "{" then
					self:constructor(ls, args)
				elseif c == "TK_STRING" then
					self:codestring(ls, args, ls.t.seminfo)
					luaX:next(ls)
				else
					luaX:syntaxerror(ls, "function arguments expected")
					return
				end
				lua_assert(f.k == "VNONRELOC")
				local base = f.info
				if self:hasmultret(args.k) then
					nparams = self.LUA_MULTRET
				else
					if args.k ~= "VVOID" then
						luaK:exp2nextreg(fs, args)
					end
					nparams = fs.freereg - (base + 1)
				end
				self:init_exp(f, "VCALL", luaK:codeABC(fs, "OP_CALL", base, nparams + 1, 2))
				luaK:fixline(fs, line)
				fs.freereg = base + 1
			end
			function luaY:prefixexp(ls, v)
				local c = ls.t.token
				if c == "(" then
					local line = ls.linenumber
					luaX:next(ls)
					self:expr(ls, v)
					self:check_match(ls, ")", "(", line)
					luaK:dischargevars(ls.fs, v)
				elseif c == "TK_NAME" then
					self:singlevar(ls, v)
				else
					luaX:syntaxerror(ls, "unexpected symbol")
				end
				return
			end
			function luaY:primaryexp(ls, v)
				local fs = ls.fs
				self:prefixexp(ls, v)
				while true do
					local c = ls.t.token
					if c == "." then
						self:field(ls, v)
					elseif c == "[" then
						local key = {}
						luaK:exp2anyreg(fs, v)
						self:yindex(ls, key)
						luaK:indexed(fs, v, key)
					elseif c == ":" then
						local key = {}
						luaX:next(ls)
						self:checkname(ls, key)
						luaK:_self(fs, v, key)
						self:funcargs(ls, v)
					elseif c == "(" or c == "TK_STRING" or c == "{" then
						luaK:exp2nextreg(fs, v)
						self:funcargs(ls, v)
					else
						return
					end
				end
			end
			function luaY:simpleexp(ls, v)
				local c = ls.t.token
				if c == "TK_NUMBER" then
					self:init_exp(v, "VKNUM", 0)
					v.nval = ls.t.seminfo
				elseif c == "TK_STRING" then
					self:codestring(ls, v, ls.t.seminfo)
				elseif c == "TK_NIL" then
					self:init_exp(v, "VNIL", 0)
				elseif c == "TK_TRUE" then
					self:init_exp(v, "VTRUE", 0)
				elseif c == "TK_FALSE" then
					self:init_exp(v, "VFALSE", 0)
				elseif c == "TK_DOTS" then
					local fs = ls.fs
					self:check_condition(
						ls,
						fs.f.is_vararg ~= 0,
						"cannot use " .. self:LUA_QL("...") .. " outside a vararg function"
					)
					local is_vararg = fs.f.is_vararg
					if is_vararg >= self.VARARG_NEEDSARG then
						fs.f.is_vararg = is_vararg - self.VARARG_NEEDSARG
					end
					self:init_exp(v, "VVARARG", luaK:codeABC(fs, "OP_VARARG", 0, 1, 0))
				elseif c == "{" then
					self:constructor(ls, v)
					return
				elseif c == "TK_FUNCTION" then
					luaX:next(ls)
					self:body(ls, v, false, ls.linenumber)
					return
				else
					self:primaryexp(ls, v)
					return
				end
				luaX:next(ls)
			end
			function luaY:getunopr(op)
				if op == "TK_NOT" then
					return "OPR_NOT"
				elseif op == "-" then
					return "OPR_MINUS"
				elseif op == "#" then
					return "OPR_LEN"
				else
					return "OPR_NOUNOPR"
				end
			end
			luaY.getbinopr_table = {
				["+"] = "OPR_ADD",
				["-"] = "OPR_SUB",
				["*"] = "OPR_MUL",
				["/"] = "OPR_DIV",
				["%"] = "OPR_MOD",
				["^"] = "OPR_POW",
				["TK_CONCAT"] = "OPR_CONCAT",
				["TK_NE"] = "OPR_NE",
				["TK_EQ"] = "OPR_EQ",
				["<"] = "OPR_LT",
				["TK_LE"] = "OPR_LE",
				[">"] = "OPR_GT",
				["TK_GE"] = "OPR_GE",
				["TK_AND"] = "OPR_AND",
				["TK_OR"] = "OPR_OR",
			}
			function luaY:getbinopr(op)
				local opr = self.getbinopr_table[op]
				if opr then
					return opr
				else
					return "OPR_NOBINOPR"
				end
			end
			luaY.priority = {
				{
					6,
					6,
				},
				{
					6,
					6,
				},
				{
					7,
					7,
				},
				{
					7,
					7,
				},
				{
					7,
					7,
				},
				{
					10,
					9,
				},
				{
					5,
					4,
				},
				{
					3,
					3,
				},
				{
					3,
					3,
				},
				{
					3,
					3,
				},
				{
					3,
					3,
				},
				{
					3,
					3,
				},
				{
					3,
					3,
				},
				{
					2,
					2,
				},
				{
					1,
					1,
				},
			}
			luaY.UNARY_PRIORITY = 8
			function luaY:subexpr(ls, v, limit)
				self:enterlevel(ls)
				local uop = self:getunopr(ls.t.token)
				if uop ~= "OPR_NOUNOPR" then
					luaX:next(ls)
					self:subexpr(ls, v, self.UNARY_PRIORITY)
					luaK:prefix(ls.fs, uop, v)
				else
					self:simpleexp(ls, v)
				end
				local op = self:getbinopr(ls.t.token)
				while op ~= "OPR_NOBINOPR" and self.priority[luaK.BinOpr[op] + 1][1] > limit do
					local v2 = {}
					luaX:next(ls)
					luaK:infix(ls.fs, op, v)
					local nextop = self:subexpr(ls, v2, self.priority[luaK.BinOpr[op] + 1][2])
					luaK:posfix(ls.fs, op, v, v2)
					op = nextop
				end
				self:leavelevel(ls)
				return op
			end
			function luaY:expr(ls, v)
				self:subexpr(ls, v, 0)
			end
			function luaY:block_follow(token)
				if
					token == "TK_ELSE"
					or token == "TK_ELSEIF"
					or token == "TK_END"
					or token == "TK_UNTIL"
					or token == "TK_EOS"
				then
					return true
				else
					return false
				end
			end
			function luaY:block(ls)
				local fs = ls.fs
				local bl = {}
				self:enterblock(fs, bl, false)
				self:chunk(ls)
				lua_assert(bl.breaklist == luaK.NO_JUMP)
				self:leaveblock(fs)
			end
			function luaY:check_conflict(ls, lh, v)
				local fs = ls.fs
				local extra = fs.freereg
				local conflict = false
				while lh do
					if lh.v.k == "VINDEXED" then
						if lh.v.info == v.info then
							conflict = true
							lh.v.info = extra
						end
						if lh.v.aux == v.info then
							conflict = true
							lh.v.aux = extra
						end
					end
					lh = lh.prev
				end
				if conflict then
					luaK:codeABC(fs, "OP_MOVE", fs.freereg, v.info, 0)
					luaK:reserveregs(fs, 1)
				end
			end
			function luaY:assignment(ls, lh, nvars)
				local e = {}
				local c = lh.v.k
				self:check_condition(
					ls,
					c == "VLOCAL" or c == "VUPVAL" or c == "VGLOBAL" or c == "VINDEXED",
					"syntax error"
				)
				if self:testnext(ls, ",") then
					local nv = {}
					nv.v = {}
					nv.prev = lh
					self:primaryexp(ls, nv.v)
					if nv.v.k == "VLOCAL" then
						self:check_conflict(ls, lh, nv.v)
					end
					self:checklimit(ls.fs, nvars, self.LUAI_MAXCCALLS - ls.L.nCcalls, "variables in assignment")
					self:assignment(ls, nv, nvars + 1)
				else
					self:checknext(ls, "=")
					local nexps = self:explist1(ls, e)
					if nexps ~= nvars then
						self:adjust_assign(ls, nvars, nexps, e)
						if nexps > nvars then
							ls.fs.freereg = ls.fs.freereg - (nexps - nvars)
						end
					else
						luaK:setoneret(ls.fs, e)
						luaK:storevar(ls.fs, lh.v, e)
						return
					end
				end
				self:init_exp(e, "VNONRELOC", ls.fs.freereg - 1)
				luaK:storevar(ls.fs, lh.v, e)
			end
			function luaY:cond(ls)
				local v = {}
				self:expr(ls, v)
				if v.k == "VNIL" then
					v.k = "VFALSE"
				end
				luaK:goiftrue(ls.fs, v)
				return v.f
			end
			function luaY:breakstat(ls)
				local fs = ls.fs
				local bl = fs.bl
				local upval = false
				while bl and not bl.isbreakable do
					if bl.upval then
						upval = true
					end
					bl = bl.previous
				end
				if not bl then
					luaX:syntaxerror(ls, "no loop to break")
				end
				if upval then
					luaK:codeABC(fs, "OP_CLOSE", bl.nactvar, 0, 0)
				end
				bl.breaklist = luaK:concat(fs, bl.breaklist, luaK:jump(fs))
			end
			function luaY:whilestat(ls, line)
				local fs = ls.fs
				local bl = {}
				luaX:next(ls)
				local whileinit = luaK:getlabel(fs)
				local condexit = self:cond(ls)
				self:enterblock(fs, bl, true)
				self:checknext(ls, "TK_DO")
				self:block(ls)
				luaK:patchlist(fs, luaK:jump(fs), whileinit)
				self:check_match(ls, "TK_END", "TK_WHILE", line)
				self:leaveblock(fs)
				luaK:patchtohere(fs, condexit)
			end
			function luaY:repeatstat(ls, line)
				local fs = ls.fs
				local repeat_init = luaK:getlabel(fs)
				local bl1, bl2 = {}, {}
				self:enterblock(fs, bl1, true)
				self:enterblock(fs, bl2, false)
				luaX:next(ls)
				self:chunk(ls)
				self:check_match(ls, "TK_UNTIL", "TK_REPEAT", line)
				local condexit = self:cond(ls)
				if not bl2.upval then
					self:leaveblock(fs)
					luaK:patchlist(ls.fs, condexit, repeat_init)
				else
					self:breakstat(ls)
					luaK:patchtohere(ls.fs, condexit)
					self:leaveblock(fs)
					luaK:patchlist(ls.fs, luaK:jump(fs), repeat_init)
				end
				self:leaveblock(fs)
			end
			function luaY:exp1(ls)
				local e = {}
				self:expr(ls, e)
				local k = e.k
				luaK:exp2nextreg(ls.fs, e)
				return k
			end
			function luaY:forbody(ls, base, line, nvars, isnum)
				local bl = {}
				local fs = ls.fs
				self:adjustlocalvars(ls, 3)
				self:checknext(ls, "TK_DO")
				local prep = isnum and luaK:codeAsBx(fs, "OP_FORPREP", base, luaK.NO_JUMP) or luaK:jump(fs)
				self:enterblock(fs, bl, false)
				self:adjustlocalvars(ls, nvars)
				luaK:reserveregs(fs, nvars)
				self:block(ls)
				self:leaveblock(fs)
				luaK:patchtohere(fs, prep)
				local endfor = isnum and luaK:codeAsBx(fs, "OP_FORLOOP", base, luaK.NO_JUMP)
					or luaK:codeABC(fs, "OP_TFORLOOP", base, 0, nvars)
				luaK:fixline(fs, line)
				luaK:patchlist(fs, isnum and endfor or luaK:jump(fs), prep + 1)
			end
			function luaY:fornum(ls, varname, line)
				local fs = ls.fs
				local base = fs.freereg
				self:new_localvarliteral(ls, "(for index)", 0)
				self:new_localvarliteral(ls, "(for limit)", 1)
				self:new_localvarliteral(ls, "(for step)", 2)
				self:new_localvar(ls, varname, 3)
				self:checknext(ls, "=")
				self:exp1(ls)
				self:checknext(ls, ",")
				self:exp1(ls)
				if self:testnext(ls, ",") then
					self:exp1(ls)
				else
					luaK:codeABx(fs, "OP_LOADK", fs.freereg, luaK:numberK(fs, 1))
					luaK:reserveregs(fs, 1)
				end
				self:forbody(ls, base, line, 1, true)
			end
			function luaY:forlist(ls, indexname)
				local fs = ls.fs
				local e = {}
				local nvars = 0
				local base = fs.freereg
				self:new_localvarliteral(ls, "(for generator)", nvars)
				nvars = nvars + 1
				self:new_localvarliteral(ls, "(for state)", nvars)
				nvars = nvars + 1
				self:new_localvarliteral(ls, "(for control)", nvars)
				nvars = nvars + 1
				self:new_localvar(ls, indexname, nvars)
				nvars = nvars + 1
				while self:testnext(ls, ",") do
					self:new_localvar(ls, self:str_checkname(ls), nvars)
					nvars = nvars + 1
				end
				self:checknext(ls, "TK_IN")
				local line = ls.linenumber
				self:adjust_assign(ls, 3, self:explist1(ls, e), e)
				luaK:checkstack(fs, 3)
				self:forbody(ls, base, line, nvars - 3, false)
			end
			function luaY:forstat(ls, line)
				local fs = ls.fs
				local bl = {}
				self:enterblock(fs, bl, true)
				luaX:next(ls)
				local varname = self:str_checkname(ls)
				local c = ls.t.token
				if c == "=" then
					self:fornum(ls, varname, line)
				elseif c == "," or c == "TK_IN" then
					self:forlist(ls, varname)
				else
					luaX:syntaxerror(ls, self:LUA_QL("=") .. " or " .. self:LUA_QL("in") .. " expected")
				end
				self:check_match(ls, "TK_END", "TK_FOR", line)
				self:leaveblock(fs)
			end
			function luaY:test_then_block(ls)
				luaX:next(ls)
				local condexit = self:cond(ls)
				self:checknext(ls, "TK_THEN")
				self:block(ls)
				return condexit
			end
			function luaY:ifstat(ls, line)
				local fs = ls.fs
				local escapelist = luaK.NO_JUMP
				local flist = self:test_then_block(ls)
				while ls.t.token == "TK_ELSEIF" do
					escapelist = luaK:concat(fs, escapelist, luaK:jump(fs))
					luaK:patchtohere(fs, flist)
					flist = self:test_then_block(ls)
				end
				if ls.t.token == "TK_ELSE" then
					escapelist = luaK:concat(fs, escapelist, luaK:jump(fs))
					luaK:patchtohere(fs, flist)
					luaX:next(ls)
					self:block(ls)
				else
					escapelist = luaK:concat(fs, escapelist, flist)
				end
				luaK:patchtohere(fs, escapelist)
				self:check_match(ls, "TK_END", "TK_IF", line)
			end
			function luaY:localfunc(ls)
				local v, b = {}, {}
				local fs = ls.fs
				self:new_localvar(ls, self:str_checkname(ls), 0)
				self:init_exp(v, "VLOCAL", fs.freereg)
				luaK:reserveregs(fs, 1)
				self:adjustlocalvars(ls, 1)
				self:body(ls, b, false, ls.linenumber)
				luaK:storevar(fs, v, b)
				self:getlocvar(fs, fs.nactvar - 1).startpc = fs.pc
			end
			function luaY:localstat(ls)
				local nvars = 0
				local nexps
				local e = {}
				repeat
					self:new_localvar(ls, self:str_checkname(ls), nvars)
					nvars = nvars + 1
				until not self:testnext(ls, ",")
				if self:testnext(ls, "=") then
					nexps = self:explist1(ls, e)
				else
					e.k = "VVOID"
					nexps = 0
				end
				self:adjust_assign(ls, nvars, nexps, e)
				self:adjustlocalvars(ls, nvars)
			end
			function luaY:funcname(ls, v)
				local needself = false
				self:singlevar(ls, v)
				while ls.t.token == "." do
					self:field(ls, v)
				end
				if ls.t.token == ":" then
					needself = true
					self:field(ls, v)
				end
				return needself
			end
			function luaY:funcstat(ls, line)
				local v, b = {}, {}
				luaX:next(ls)
				local needself = self:funcname(ls, v)
				self:body(ls, b, needself, line)
				luaK:storevar(ls.fs, v, b)
				luaK:fixline(ls.fs, line)
			end
			function luaY:exprstat(ls)
				local fs = ls.fs
				local v = {}
				v.v = {}
				self:primaryexp(ls, v.v)
				if v.v.k == "VCALL" then
					luaP:SETARG_C(luaK:getcode(fs, v.v), 1)
				else
					v.prev = nil
					self:assignment(ls, v, 1)
				end
			end
			function luaY:retstat(ls)
				local fs = ls.fs
				local e = {}
				local first, nret
				luaX:next(ls)
				if self:block_follow(ls.t.token) or ls.t.token == ";" then
					first, nret = 0, 0
				else
					nret = self:explist1(ls, e)
					if self:hasmultret(e.k) then
						luaK:setmultret(fs, e)
						if e.k == "VCALL" and nret == 1 then
							luaP:SET_OPCODE(luaK:getcode(fs, e), "OP_TAILCALL")
							lua_assert(luaP:GETARG_A(luaK:getcode(fs, e)) == fs.nactvar)
						end
						first = fs.nactvar
						nret = self.LUA_MULTRET
					else
						if nret == 1 then
							first = luaK:exp2anyreg(fs, e)
						else
							luaK:exp2nextreg(fs, e)
							first = fs.nactvar
							lua_assert(nret == fs.freereg - first)
						end
					end
				end
				luaK:ret(fs, first, nret)
			end
			function luaY:statement(ls)
				local line = ls.linenumber
				local c = ls.t.token
				if c == "TK_IF" then
					self:ifstat(ls, line)
					return false
				elseif c == "TK_WHILE" then
					self:whilestat(ls, line)
					return false
				elseif c == "TK_DO" then
					luaX:next(ls)
					self:block(ls)
					self:check_match(ls, "TK_END", "TK_DO", line)
					return false
				elseif c == "TK_FOR" then
					self:forstat(ls, line)
					return false
				elseif c == "TK_REPEAT" then
					self:repeatstat(ls, line)
					return false
				elseif c == "TK_FUNCTION" then
					self:funcstat(ls, line)
					return false
				elseif c == "TK_LOCAL" then
					luaX:next(ls)
					if self:testnext(ls, "TK_FUNCTION") then
						self:localfunc(ls)
					else
						self:localstat(ls)
					end
					return false
				elseif c == "TK_RETURN" then
					self:retstat(ls)
					return true
				elseif c == "TK_BREAK" then
					luaX:next(ls)
					self:breakstat(ls)
					return true
				else
					self:exprstat(ls)
					return false
				end
			end
			function luaY:chunk(ls)
				local islast = false
				self:enterlevel(ls)
				while not islast and not self:block_follow(ls.t.token) do
					islast = self:statement(ls)
					self:testnext(ls, ";")
					lua_assert(ls.fs.f.maxstacksize >= ls.fs.freereg and ls.fs.freereg >= ls.fs.nactvar)
					ls.fs.freereg = ls.fs.nactvar
				end
				self:leavelevel(ls)
			end
			luaX:init()
			local LuaState = {}
			function compile(source, name)
				name = name or "compiled-lua"
				local zio = luaZ:init(luaZ:make_getF(source), nil)
				if not zio then
					return
				end
				local func = luaY:parser(LuaState, zio, nil, "@" .. name)
				local writer, buff = luaU:make_setS()
				luaU:dump(LuaState, func, writer, buff)
				return Serialize(Deserialize(buff.data))
			end
			return compile
		end
		function _legacyluaprotector.s()
			local v = _legacyluaprotector.cache.s
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.s = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Parts = _legacyluaprotector.n()
			local GetOpcodeCode = _legacyluaprotector.o()
			local compile = _legacyluaprotector.s()
			math.randomseed(os.time())
			local function generate(...)
				local data = {
					...,
				}
				local bytecode = data[1]
				local used_opcodes = data[2]
				local lines = {}
				local function add(line)
					lines[#lines + 1] = line
				end
				local function generateVariable(length)
					local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
					local result = {}
					for i = 1, length do
						local rand = math.random(1, #charset)
						table.insert(result, charset:sub(rand, rand))
					end
					return table.concat(result)
				end
				local function stringShuffle(str)
					local n = #str
					local codes = {}
					for i = 1, n do
						codes[i] = str:byte(i)
					end
					for i = n, 2, -1 do
						local j = math.random(1, i)
						codes[i], codes[j] = codes[j], codes[i]
					end
					for i = 1, n do
						codes[i] = string.char(codes[i])
					end
					return table.concat(codes)
				end
				local function getChar(n)
					local out = {}
					for i = 1, n do
						out[#out + 1] = string.char(i)
					end
					return table.concat(out)
				end
				local charset = stringShuffle(getChar(94))
				local base, encode_lookup, decode_lookup = #charset, {}, {}
				for i = 1, base do
					local c = charset:sub(i, i)
					encode_lookup[i - 1], decode_lookup[c] = c, i - 1
				end
				local function encodeNumber(n)
					local e = {}
					repeat
						local r = n % base
						table.insert(e, 1, encode_lookup[r])
						n = math.floor(n / base)
					until n == 0
					return table.concat(e)
				end
				local function encodeString(str)
					local encoded = {}
					for i = 1, #str do
						local char = str:sub(i, i)
						table.insert(encoded, encodeNumber(char:byte()))
					end
					return table.concat(encoded, "_")
				end
				local function encode(str_param, yes)
					yes = yes or false
					if not yes then
						str_param = encodeString(str_param)
					end
					local out = {}
					for i = 1, #str_param do
						local b = string.byte(str_param, i)
						table.insert(out, "\\" .. b)
					end
					return table.concat(out)
				end
				add("zuka,v2,beta,__,_ = 'get a load of this', function()end, true, 1, 0")
				add(Parts.Variables)
				add(Parts.Deserializer)
				add(Parts.Wrapper_1)
				local k = "if"
				for i, v in pairs(used_opcodes) do
					local op = used_opcodes[v]
					add(k .. " (S == " .. op .. ") then\n")
					add(GetOpcodeCode(op))
					k = "elseif"
				end
				add("end")
				add(Parts.Wrapper_2)
				add(
					"WrapState(BcToState('"
						.. encode(bytecode)
						.. "','"
						.. encode(charset, true)
						.. "'),(getfenv and getfenv(0)) or _ENV)()"
				)
				return table.concat(lines, "\n")
			end
			local VM = {}
			function VM.process(source)
				_G.UsedOps = _G.UsedOps or {}
				_G.UsedOps[0] = 0
				_G.UsedOps[4] = 4
				source = generate(compile(source), _G.UsedOps)
				return source
			end
			return VM
		end
		function _legacyluaprotector.t()
			local v = _legacyluaprotector.cache.t
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.t = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local AntiTamper = {}
			function AntiTamper.process(code)
				local anti_tamper_code = [[
            do  
                local D,T,P,X,S,E,R,Pa,GM,SM,RG,RS,RE,CG,Sel,C,G=  
                    debug,type,pcall,xpcall,tostring,error,rawget,pairs,  
                    getmetatable,setmetatable,rawget,rawset,rawequal,collectgarbage,select,coroutine,_G  
                local function dbgOK()  
                    if T(D)~="table" then return false end  
                    for _,k in Pa{"getinfo","getlocal","getupvalue","traceback","sethook","setupvalue","getregistry"} do  
                        if T(D[k])~="function" then return false end  
                    end  
                    return true  
                end  
                if not dbgOK() then E("Tamper Detected! Reason: Debug library incomplete") return end  
                local function isNative(f)  
                    local i=D.getinfo(f)  
                    return i and i.what=="C"  
                end  
                local function checkNativeFuncs()  
                    local natives={  
                        P,X,assert,E,print,RG,RS,RE,tonumber,S,T,  
                        Sel,next,ipairs,Pa,CG,GM,SM,  
                        load,loadstring,loadfile,dofile,collectgarbage,  
                        D.getinfo,D.getlocal,D.getupvalue,D.sethook,D.setupvalue,D.traceback,  
                        C.create,C.resume,C.yield,C.status,  
                        math.abs,math.acos,math.asin,math.atan,math.ceil,math.cos,math.deg,math.exp,  
                        math.floor,math.fmod,math.huge,math.log,math.max,math.min,math.modf,math.pi,  
                        math.rad,math.random,math.sin,math.sqrt,math.tan,  
                        os.clock,os.date,os.difftime,os.execute,os.exit,os.getenv,os.remove,  
                        os.rename,os.setlocale,os.time,os.tmpname,  
                        string.byte,string.char,string.dump,string.find,string.format,string.gmatch,  
                        string.gsub,string.len,string.lower,string.match,string.rep,string.reverse,  
                        string.sub,string.upper,  
                        table.insert,table.maxn,table.remove,table.sort  
                    }  
                    local mts={string,table,math,os,G,package}  
                    for _,t in Pa(mts) do  
                        local mt=GM(t)  
                        if mt then  
                            for _,m in Pa{"__index","__newindex","__call","__metatable"} do  
                                local mf=mt[m]  
                                if mf and T(mf)=="function" and not isNative(mf) then  
                                    return false,"Metamethod tampered: "..m  
                                end  
                            end  
                        end  
                    end  
                    for _,fn in Pa(natives) do  
                        if T(fn)=="function" and not isNative(fn) then  
                            return false,"Native function replaced or wrapped"  
                        end  
                    end  
                    return true  
                end  
                local function isMinified(f)  
                    local i=D.getinfo(f,"Sl")  
                    return i and i.linedefined==i.lastlinedefined  
                end  
                local function scanUp(f)  
                    local i=1  
                    while true do  
                        local n,v=D.getupvalue(f,i)  
                        if not n then break end  
                        if T(v)=="function" and not isMinified(v) then return false,"Suspicious upvalue: "..n end  
                        i=i+1  
                    end  
                    return true  
                end  
                local function scanLocals(l)  
                    local i=1  
                    while true do  
                        local n,v=D.getlocal(l,i)  
                        if not n then break end  
                        if T(v)=="function" and not isMinified(v) then return false,"Suspicious local: "..n end  
                        i=i+1  
                    end  
                    return true  
                end  
                local function checkGlobals()  
                    local essentials={"pcall","xpcall","type","tostring","string","table","debug","coroutine","math","os","package"}  
                    for _,k in Pa(essentials) do  
                        if T(G[k])~=T(_G[k]) then return false,"Global modified: "..k end  
                    end  
                    if package and package.loaded and T(package.loaded.debug)~="table" then  
                        return false,"Package.debug modified"  
                    end  
                    return true  
                end  
                local function run()  
                    local ok,r=checkNativeFuncs()  
                    if not ok then return false,r end  
                    ok,r=checkGlobals()  
                    if not ok then return false,r end  
                    for l=2,4 do  
                        local i=D.getinfo(l,"f")  
                        if i and i.func then  
                            ok,r=scanUp(i.func)  
                            if not ok then return false,r.." @lvl "..l end  
                        end  
                        ok,r=scanLocals(l)  
                        if not ok then return false,r.." @lvl "..l end  
                    end  
                    return true  
                end  
                local ok,r=run()  
                if not ok then  
                    E("Tamper Detected! Reason: "..S(r))  
                    while true do E("Tamper Detected! Reason: "..S(r)) end  
                end  
            end
            ]]
				return anti_tamper_code .. "\n" .. code
			end
			return AntiTamper
		end
		function _legacyluaprotector.u()
			local v = _legacyluaprotector.cache.u
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.u = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local config = _legacyluaprotector.a()
			local StringEncoder = _legacyluaprotector.b()
			local VariableRenamer = _legacyluaprotector.c()
			local ControlFlowObfuscator = _legacyluaprotector.d()
			local GarbageCodeInserter = _legacyluaprotector.e()
			local OpaquePredicateInjector = _legacyluaprotector.f()
			local FunctionInliner = _legacyluaprotector.g()
			local DynamicCodeGenerator = _legacyluaprotector.h()
			local BytecodeEncoder = _legacyluaprotector.i()
			local Watermarker = _legacyluaprotector.j()
			local Compressor = _legacyluaprotector.k()
			local StringToExpressions = _legacyluaprotector.l()
			local WrapInFunction = _legacyluaprotector.m()
			local VirtualMachinery = _legacyluaprotector.t()
			local AntiTamper = _legacyluaprotector.u()
			local Pipeline = {}
			function Pipeline.process(code)
				if config.get("settings.string_encoding.enabled") then
					code = StringEncoder.process(code)
				end
				if config.get("settings.garbage_code.enabled") then
					local garbage_blocks = config.get("settings.garbage_code.garbage_blocks")
					code = GarbageCodeInserter.process(code, garbage_blocks)
				end
				if config.get("settings.dynamic_code.enabled") then
					code = DynamicCodeGenerator.process(code)
				end
				if config.get("settings.opaque_predicates.enabled") then
					code = OpaquePredicateInjector.process(code)
				end
				if config.get("settings.bytecode_encoding.enabled") then
					code = BytecodeEncoder.process(code)
				end
				if config.get("settings.function_inlining.enabled") then
					code = FunctionInliner.process(code)
				end
				if config.get("settings.StringToExpressions.enabled") then
					local min_length = config.get("settings.StringToExpressions.min_number_length")
					local max_length = config.get("settings.StringToExpressions.max_number_length")
					code = StringToExpressions.process(code, min_length, max_length)
				end
				if config.get("settings.antitamper.enabled") then
					code = AntiTamper.process(code)
				end
				if config.get("settings.VirtualMachine.enabled") then
					code = VirtualMachinery.process(code)
				end
				if config.get("settings.control_flow.enabled") then
					local max_fake_blocks = config.get("settings.control_flow.max_fake_blocks")
					code = ControlFlowObfuscator.process(code, max_fake_blocks)
				end
				if config.get("settings.garbage_code.enabled") then
					local garbage_blocks = config.get("settings.garbage_code.garbage_blocks")
					code = GarbageCodeInserter.process(code, garbage_blocks)
				end
				if config.get("settings.variable_renaming.enabled") then
					local min_length = config.get("settings.variable_renaming.min_name_length")
					local max_length = config.get("settings.variable_renaming.max_name_length")
					code = VariableRenamer.process(code, { min_length = min_length, max_length = max_length })
				end
				if config.get("settings.compressor.enabled") then
					code = Compressor.process(code)
				end
				if config.get("settings.WrapInFunction.enabled") then
					code = WrapInFunction.process(code)
				end
				if config.get("settings.watermark_enabled") then
					code = Watermarker.process(code)
				end
				return code
			end
			return Pipeline
		end
		function _legacyluaprotector.v()
			local v = _legacyluaprotector.cache.v
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.v = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Pipeline = _legacyluaprotector.v()
			local config = _legacyluaprotector.a()
			local function filesize(file)
				local f = io.open(file, "r")
				if not f then
					return 0
				end
				local sz
				local success, err = pcall(function()
					sz = f:seek("end")
				end)
				f:close()
				if not success then
					return 0
				end
				return sz
			end
			local function map(func, tbl)
				local mapped = {}
				for k, v in pairs(tbl) do
					mapped[k] = func(v, k)
				end
				return mapped
			end
			local colors = {
				reset = "\27[0m",
				green = "\27[32m",
				red = "\27[31m",
				white = "\27[37m",
				cyan = "\27[36m",
				blue = "\27[34m",
				yellow = "\27[33m",
			}
			local obfuscated_list = {}
			local BANNER = colors.blue
				.. [[
            __________      __         ___________           .__     
            \____    /__ __|  | _______\__    ___/___   ____ |  |__  
              /     /|  |  \  |/ /\__  \ |    |_/ __ \_/ ___\|  |  \ 
             /     /_|  |  /    <  / __ \|    |\  ___/\  \___|   Y  \
            /_______ \____/|__|_ \(____  /____| \___  >\___  >___|  /
                    \/          \/     \/           \/     \/     \/
            ]]
				.. colors.reset
			local function runSanityCheck(original_code, obfuscated_code)
				local function captureOutput(code)
					local output = {}
					local ogprint = _G.print
					local success, result = pcall(function()
						_G.print = function(...)
							local args = { ... }
							local str = table.concat(map(tostring, args), "\t")
							table.insert(output, str)
						end
						local func, err = load(code)
						if not func then
							error("Compilation error: " .. tostring(err))
						end
						local status, run_result = pcall(func)
						if not status then
							error("Runtime error: " .. tostring(run_result))
						end
					end)
					_G.print = ogprint
					if not success then
						return "", result
					end
					return table.concat(output, "\n"), nil
				end
				local original_output, original_err = captureOutput(original_code)
				local obfuscated_output, obfuscated_err = captureOutput(obfuscated_code)
				if original_err or obfuscated_err then
					return false,
						{ expected = original_err or original_output, got = obfuscated_err or obfuscated_output }
				end
				return original_output == obfuscated_output, { expected = original_output, got = obfuscated_output }
			end
			local function printCliResult(input, output, time, options)
				local original_size = filesize(input)
				local obfuscated_size = output and filesize(output) or 0
				local size_diff_percent
				if original_size > 0 then
					size_diff_percent =
						string.format("%.2f", ((obfuscated_size - original_size) / original_size) * 100 + 100)
				else
					size_diff_percent = "N/A"
				end
				local line = colors.white .. string.rep("═", 65) .. colors.reset
				print("\n" .. line)
				print(BANNER)
				print(colors.white .. "Obfuscation Complete!" .. colors.reset)
				print(colors.white .. "Details:" .. colors.reset)
				print(line)
				print(
					colors.white .. "Time Taken        : " .. string.format("%.2f", time) .. " seconds" .. colors.reset
				)
				print(colors.cyan .. "Original Size     : " .. original_size .. " bytes" .. colors.reset)
				print(colors.cyan .. "Obfuscated Size   : " .. obfuscated_size .. " bytes" .. colors.reset)
				print(
					colors.cyan
						.. "Size Difference   : "
						.. (obfuscated_size - original_size)
						.. " bytes ("
						.. size_diff_percent
						.. "%)"
						.. colors.reset
				)
				local function formatBool(val)
					return val and colors.green .. "True" .. colors.reset or colors.red .. "False" .. colors.reset
				end
				print(colors.cyan .. "Overwrite         : " .. formatBool(options.overwrite))
				print(colors.cyan .. "Folder Mode       : " .. formatBool(options.folder_mode))
				if options.folder_mode then
					if not output then
						print(
							colors.white
								.. "Output File       : "
								.. colors.reset
								.. colors.cyan
								.. table.concat(obfuscated_list, ", ")
								.. colors.reset
						)
					end
				else
					print(colors.white .. "Output File       : " .. output .. colors.reset)
				end
				if options.sanity_check then
					if options.sanity_failed then
						print(colors.red .. "Sanity Check      : Failed" .. colors.reset)
						print(colors.yellow .. "\nExpected output:" .. colors.reset)
						print(colors.white .. options.sanity_info.expected .. colors.reset)
						print(colors.yellow .. "\nGot output:" .. colors.reset)
						print(colors.white .. options.sanity_info.got .. colors.reset)
						print(colors.red .. "skid? like the skid marks in your undies?" .. colors.reset)
						print(colors.red .. "the exploit community are cringe and dorky as fuck" .. colors.reset)
					else
						print(colors.green .. "Sanity Check      : Passed" .. colors.reset)
					end
				end
				print(line)
				local settings = {
					{ "Watermark", config.get("settings.watermark_enabled") },
					{ "String To Expressions", config.get("settings.StringToExpressions.enabled") },
					{ "Control Flow", config.get("settings.control_flow.enabled") },
					{ "String Encoding", config.get("settings.string_encoding.enabled") },
					{ "Variable Renaming", config.get("settings.variable_renaming.enabled") },
					{ "Garbage Code", config.get("settings.garbage_code.enabled") },
					{ "Opaque Predicates", config.get("settings.opaque_predicates.enabled") },
					{ "Function Inlining", config.get("settings.function_inlining.enabled") },
					{ "Dynamic Code", config.get("settings.dynamic_code.enabled") },
					{ "Bytecode Encoding", config.get("settings.bytecode_encoding.enabled") },
					{ "Compressor", config.get("settings.compressor.enabled") },
					{ "Function Wrapping", config.get("settings.WrapInFunction.enabled") },
					{ "Virtual Machine", config.get("settings.VirtualMachine.enabled") },
					{ "Anti Tamper", config.get("settings.antitamper.enabled") },
				}
				local max_length = 0
				for _, setting in ipairs(settings) do
					if #setting[1] > max_length then
						max_length = #setting[1]
					end
				end
				for _, setting in ipairs(settings) do
					local name = setting[1]
					local status = (setting[2] and colors.green .. "Enabled" or colors.red .. "Disabled")
					local padding = string.rep(" ", max_length - #name + 1)
					print(colors.white .. name .. padding .. ":" .. " " .. status .. colors.reset)
				end
				print(line .. "\n")
			end
			local function applyPreset(level)
				if level == "min" then
					config.set("settings.variable_renaming.min_name_length", 10)
					config.set("settings.variable_renaming.max_name_length", 20)
					config.set("settings.garbage_code.garbage_blocks", 5)
					config.set("settings.control_flow.max_fake_blocks", 2)
				elseif level == "mid" then
					config.set("settings.variable_renaming.min_name_length", 40)
					config.set("settings.variable_renaming.max_name_length", 60)
					config.set("settings.garbage_code.garbage_blocks", 25)
					config.set("settings.control_flow.max_fake_blocks", 8)
				elseif level == "max" then
					config.set("settings.variable_renaming.min_name_length", 90)
					config.set("settings.variable_renaming.max_name_length", 120)
					config.set("settings.garbage_code.garbage_blocks", 50)
					config.set("settings.control_flow.max_fake_blocks", 12)
					config.set("settings.StringToExpressions.min_number_length", 800)
					config.set("settings.StringToExpressions.max_number_length", 999)
				end
			end
			local function printUsage()
				print(
					colors.white
						.. "Usage: "
						.. colors.reset
						.. colors.cyan
						.. "./zukv4.lua *.lua (+ any options)"
						.. colors.reset
				)
				print(colors.white .. "\nOptional Presets:" .. colors.reset)
				print(
					colors.cyan
						.. "--min"
						.. string.rep(" ", 17)
						.. colors.green
						.. "Minimal parameters for lighter obfuscation"
						.. colors.reset
				)
				print(
					colors.cyan
						.. "--mid"
						.. string.rep(" ", 17)
						.. colors.green
						.. "Moderate parameters for balanced obfuscation"
						.. colors.reset
				)
				print(
					colors.cyan
						.. "--max"
						.. string.rep(" ", 17)
						.. colors.green
						.. "Maximum parameters for heavy obfuscation"
						.. colors.reset
				)
				print(colors.white .. "\nGeneral Flags:" .. colors.reset)
				local general_flags = {
					{ flags = { "--overwrite", "" }, description = "Overwrites the original file with obfuscated code" },
					{ flags = { "--folder", "" }, description = "Process all Lua files in the given folder" },
					{ flags = { "--sanity", "" }, description = "Check if obfuscated code output matches original" },
				}
				for _, flag in ipairs(general_flags) do
					print(
						colors.cyan
							.. flag.flags[1]
							.. flag.flags[2]
							.. colors.green
							.. string.rep(" ", 20 - #flag.flags[1] - #flag.flags[2])
							.. flag.description
							.. colors.reset
					)
				end
				print(colors.white .. "\nObfuscation Flags:" .. colors.reset)
				local obfuscation_flags = {
					{ flags = { "-cf", "--control_flow" }, description = "Enable control flow obfuscation" },
					{ flags = { "-se", "--string_encoding" }, description = "Enable string encoding" },
					{ flags = { "-vr", "--variable_renaming" }, description = "Enable variable renaming" },
					{ flags = { "-gci", "--garbage_code" }, description = "Enable garbage code injection" },
					{ flags = { "-opi", "--opaque_preds" }, description = "Enable opaque predicates injection" },
					{ flags = { "-be", "--bytecode_encoder" }, description = "Enable bytecode encoding" },
					{ flags = { "-st", "--string_to_expr" }, description = "Enable string to expression conversion" },
					{ flags = { "-vm", "--virtual_machine" }, description = "Enable virtual machine transformation" },
					{ flags = { "-wif", "--wrap_in_func" }, description = "Enable function wrapping" },
					{ flags = { "-fi", "--func_inlining" }, description = "Enable function inlining" },
					{ flags = { "-dc", "--dynamic_code" }, description = "Enable dynamic code generation" },
					{ flags = { "-c", "--compressor" }, description = "Enable compressor" },
					{ flags = { "-at", "--antitamper" }, description = "Enable antitamper" },
				}
				local max_flag_length = 0
				for _, flag in ipairs(obfuscation_flags) do
					local short_flag = flag.flags[1]
					local long_flag = flag.flags[2]
					max_flag_length = math.max(max_flag_length, #short_flag + #long_flag + 2)
				end
				for _, flag in ipairs(obfuscation_flags) do
					local short_flag = flag.flags[1]
					local long_flag = flag.flags[2]
					local padding = string.rep(" ", max_flag_length - (#short_flag + #long_flag + 2))
					print(
						colors.cyan
							.. short_flag
							.. ", "
							.. long_flag
							.. padding
							.. colors.white
							.. ": "
							.. colors.green
							.. flag.description
							.. colors.reset
					)
				end
				os.exit(1)
			end
			local function main()
				if #arg < 1 then
					print(colors.red .. "Error: No input file specified" .. colors.reset)
					printUsage()
					os.exit(1)
				end
				local input = arg[1]
				if input:sub(1, 1) == "-" then
					print(colors.red .. "Error: Unexpected flag '" .. input .. "'" .. colors.reset)
					printUsage()
					os.exit(1)
				end
				local options = {
					overwrite = false,
					custom_file = nil,
					folder_mode = false,
					sanity_check = false,
				}
				local features = {
					control_flow = false,
					string_encoding = false,
					variable_renaming = false,
					garbage_code = false,
					opaque_predicates = false,
					bytecode_encoding = false,
					compressor = false,
					StringToExpressions = false,
					VirtualMachine = false,
					WrapInFunction = false,
					function_inlining = false,
					dynamic_code = false,
					antitamper = false,
				}
				for i = 2, #arg do
					if arg[i] == "--overwrite" then
						options.overwrite = true
					elseif arg[i] == "--folder" then
						options.folder_mode = true
					elseif arg[i] == "--sanity" then
						options.sanity_check = true
					elseif arg[i] == "-cf" or arg[i] == "--control_flow" then
						features.control_flow = true
					elseif arg[i] == "-c" or arg[i] == "--compressor" then
						features.compressor = true
					elseif arg[i] == "-se" or arg[i] == "--string_encoding" then
						features.string_encoding = true
					elseif arg[i] == "-vr" or arg[i] == "--variable_renaming" then
						features.variable_renaming = true
					elseif arg[i] == "-gci" or arg[i] == "--garbage_code" then
						features.garbage_code = true
					elseif arg[i] == "-opi" or arg[i] == "--opaque_preds" then
						features.opaque_predicates = true
					elseif arg[i] == "-be" or arg[i] == "--bytecode_encoder" then
						features.bytecode_encoding = true
					elseif arg[i] == "-st" or arg[i] == "--string_to_expr" then
						features.StringToExpressions = true
					elseif arg[i] == "-vm" or arg[i] == "--virtual_machine" then
						features.VirtualMachine = true
					elseif arg[i] == "-wif" or arg[i] == "--wrap_in_func" then
						features.WrapInFunction = true
					elseif arg[i] == "-fi" or arg[i] == "--func_inlining" then
						features.function_inlining = true
					elseif arg[i] == "-dc" or arg[i] == "--dynamic_code" then
						features.dynamic_code = true
					elseif arg[i] == "-at" or arg[i] == "--antitamper" then
						features.antitamper = true
					elseif arg[i] == "--min" then
						options.preset_level = "min"
					elseif arg[i] == "--mid" then
						options.preset_level = "mid"
					elseif arg[i] == "--max" then
						options.preset_level = "max"
					else
						print(colors.red .. "Error: Unknown option '" .. arg[i] .. "'" .. colors.reset)
						printUsage()
						os.exit(1)
					end
				end
				if not options.folder_mode and not input:match("%.lua$") then
					print(colors.red .. "Error: Invalid file extension for '" .. input .. "'" .. colors.reset)
					printUsage()
					os.exit(1)
				end
				if options.folder_mode then
					if not os.rename(input, input) then
						print(
							colors.red
								.. "Error: Folder '"
								.. input
								.. "' does not exist or could not be found"
								.. colors.reset
						)
						printUsage()
						os.exit(1)
					end
				else
					local fh = io.open(input, "r")
					if not fh then
						print(
							colors.red
								.. "Error: File '"
								.. input
								.. "' does not exist or could not be found"
								.. colors.reset
						)
						printUsage()
						os.exit(1)
					end
					fh:close()
				end
				local single_enabled = false
				for feature in pairs(features) do
					if features[feature] then
						single_enabled = true
						break
					end
				end
				if single_enabled then
					for feature, enabled in pairs(features) do
						config.settings[feature].enabled = enabled
					end
				end
				local files = {}
				if options.folder_mode then
					local find_command
					if package.config:sub(1, 1) == "\\" then
						local pattern = input .. "\\*.lua"
						find_command = string.format("dir %q /b /s 2>nul", pattern)
					else
						find_command = string.format('find %q -type f -name "*.lua"', input)
					end
					local p = io.popen(find_command)
					if not p then
						error("Error: Failed to execute find command: " .. find_command)
					end
					for file in p:lines() do
						table.insert(files, file)
					end
					p:close()
				else
					table.insert(files, input)
				end
				obfuscated_list = {}
				local batch_start = os.clock()
				for _, file_path in ipairs(files) do
					local file = io.open(file_path, "r")
					if not file then
						print("Error: Could not open file " .. file_path)
						os.exit(1)
					end
					local code = file:read("*all")
					file:close()
					local start_time = os.clock()
					local obfuscated_code, sanity_failed, sanity_info
					local attempts, success = 0, false
					repeat
						attempts = attempts + 1
						if options.custom_file then
							local ok, custom = pcall(require, options.custom_file)
							if not ok then
								print("Error: Could not load custom pipeline module: " .. tostring(custom))
								os.exit(1)
							end
							obfuscated_code = custom.process(code)
						else
							obfuscated_code = Pipeline.process(code)
						end
						if options.sanity_check then
							success, sanity_info = runSanityCheck(code, obfuscated_code)
							if not success and attempts >= 3 then
								sanity_failed = true
								break
							end
						else
							success = true
						end
					until success or attempts >= 3
					local output_file = options.overwrite and file_path or file_path:gsub("%.lua$", "_obfuscated.lua")
					local out_file_handle = assert(io.open(output_file, "w"))
					out_file_handle:write(obfuscated_code)
					out_file_handle:close()
					table.insert(obfuscated_list, output_file)
					local file_time = os.clock() - start_time
					options.sanity_failed = sanity_failed
					options.sanity_info = sanity_info
					if not options.folder_mode then
						printCliResult(file_path, output_file, file_time, options)
					end
				end
				if options.folder_mode then
					local total_time = os.clock() - batch_start
					printCliResult(input, nil, total_time, options)
				end
			end
			main()
		end
		function _legacyluaprotector.w()
			local v = _legacyluaprotector.cache.w
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.w = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local zukv4 = _legacyluaprotector.w()
			return zukv4
		end
		function _legacyluaprotector.x()
			local v = _legacyluaprotector.cache.x
			if not v then
				v = { c = __modImpl() }
				_legacyluaprotector.cache.x = v
			end
			return v.c
		end
	end
end
_legacyluaprotector.x()