{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n//lit\n\n// Half-a-Q*bert, by @ko_si_nus\n// This is a cludge, but by god it works.\n\n// - Q*bert will follow the mouse.\n// - Jumping off the board will simply move you back to the top.\n// - There's no win condition, but you can toggle each tile twice.\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nuniform sampler2D backbuffer;\n\nconst float PI = 3.141592653589793;\nconst float HALFPI = PI / 2.0;\nconst float TAN30 = 0.5773502691896256;\nconst float COS30 = 0.8660254037844387;\nconst float SIN30 = 0.5;\nconst float XPERIOD = 2.0 * COS30;\nconst float YPERIOD = 2.0 + 2.0 * SIN30;\nconst float HALFXPERIOD = XPERIOD / 2.0;\nconst float HALFYPERIOD = YPERIOD / 2.0;\nconst float SCALE = 14.0;\nconst vec4 LSHADE = vec4(0.2, 0.2, 0.2, 1.0);\nconst vec4 RSHADE = vec4(0.3, 0.3, 0.3, 1.0);\n\nvec4 stateToValues(float x) {\n\tvec4 color = texture2D(backbuffer, vec2(x + 0.5, 0.5) / resolution.xy);\n\treturn floor(color * 255.0 + 0.5);\n}\n\nvec4 valuesToState(float r, float g, float b) {\n\treturn vec4(r / 255.0, g / 255.0, b / 255.0, 1.0);\n}\n\nvec3 idxToCube(float idx) {\n\tvec3 cube = vec3(0.0, 0.0, idx);\n\tcube.x = mod(cube.z, 10.0) - 2.0;\n\tcube.y = floor(cube.z / 10.0) - 1.0;\n\treturn cube;\n}\n\nfloat cubeToIdx(vec3 cube) {\n\treturn (cube.y + 1.0) * 10.0 + cube.x + 2.0;\n}\n\nvec2 cubeToPos(vec3 cube) {\n\treturn vec2(\n\t\t(cube.x + cube.y / 2.0) * XPERIOD,\n\t\t(cube.y + 2.0) * HALFYPERIOD);\n}\n\nvoid main(void) {\n\tvec4 color;\n\t\n\t// r = currentFlank, g = playerFrom, b = playerTo\n\tvec4 state = stateToValues(0.0);\n\t\n\tfloat tick = time / 0.8;\n\tfloat flank = mod(floor(tick), 30.0);\n\tfloat tickOff = flank != state.r ? 1.0 : fract(tick);\n\t\n\tfloat scale = resolution.y / SCALE;\n\tvec2 padding = vec2((resolution.x / scale - 6.0 * XPERIOD) / 2.0, 0.0);\n\tvec2 position = gl_FragCoord.xy / scale - padding;\n\t\n\tvec3 fromCube = idxToCube(state.g);\n\tvec3 toCube = idxToCube(state.b);\n\tvec2 fromPos = cubeToPos(fromCube);\n\tvec2 toPos = cubeToPos(toCube);\n\tvec2 playerPos = mix(fromPos, toPos, tickOff);\n\tif (tickOff < 0.4) {\n\t\tplayerPos.y += sqrt(tickOff / 0.4);\n\t}\n\telse {\n\t\tplayerPos.y += sqrt(1.0 - (tickOff - 0.4) / 0.6);\n\t}\n\t\n\tif (gl_FragCoord.y < 1.0) {\n\t\tif (gl_FragCoord.x < 1.0) {\n\t\t\tif (state.r != flank) {\n\t\t\t\tvec2 mouseDelta = (mouse * resolution / scale - padding) - toPos;\n\t\t\t\tfloat angle = atan(mouseDelta.y, mouseDelta.x);\n\t\t\t\tif (toCube.y < 0.0 || toCube.y >= 7.0 || toCube.x < 0.0 || toCube.x >= 7.0 - toCube.y) {\n\t\t\t\t\ttoCube.x = 0.0;\n\t\t\t\t\ttoCube.y = 6.0;\n\t\t\t\t}\n\t\t\t\telse if (angle < -HALFPI) {\n\t\t\t\t\ttoCube.y -= 1.0;\n\t\t\t\t}\n\t\t\t\telse if (angle < 0.0) {\n\t\t\t\t\ttoCube.y -= 1.0;\n\t\t\t\t\ttoCube.x += 1.0;\n\t\t\t\t}\n\t\t\t\telse if (angle < HALFPI) {\n\t\t\t\t\ttoCube.y += 1.0;\n\t\t\t\t}\n\t\t\t\telse {\n\t\t\t\t\ttoCube.y += 1.0;\n\t\t\t\t\ttoCube.x -= 1.0;\n\t\t\t\t}\n\t\t\t\tcolor = valuesToState(flank, state.b, cubeToIdx(toCube));\n\t\t\t}\n\t\t\telse {\n\t\t\t\tcolor = valuesToState(flank, state.g, state.b);\n\t\t\t}\n\t\t\t//color = valuesToState(flank, 25.0, 25.0);\n\t\t}\n\t\t\n\t\telse {\n\t\t\tvec3 cube = idxToCube(floor(gl_FragCoord.x - 1.0));\n\t\t\tfloat steps = stateToValues(1.0 + cube.z).r;\n\t\t\t\n\t\t\tif (cube.y < 0.0 || cube.y >= 7.0 || cube.x < 0.0 || cube.x >= 7.0 - cube.y)\n\t\t\t\tsteps = 0.0;\n\t\t\telse if (state.r != flank && state.b == cube.z)\n\t\t\t\tsteps += 1.0;\n\t\t\tcolor = valuesToState(clamp(steps, 0.0, 2.0), 0.0, 0.0);\n\t\t}\n\t}\n\t\n\telse if (distance(playerPos, position) < 0.2) {\n\t\tcolor = vec4(1.0, 1.0, 1.0, 1.0);\n\t}\n\t\n\telse {\n\t\tfloat x;\n\t\tfloat y = mod(position.y, YPERIOD);\n\t\tfloat upper = step(HALFYPERIOD, y);\n\t\tif (upper == 0.0) {\n\t\t\tx = mod(position.x, XPERIOD);\n\t\t}\n\t\telse {\n\t\t\tx = mod(position.x + HALFXPERIOD, XPERIOD);\n\t\t\ty -= HALFYPERIOD;\n\t\t}\n\t\t\n\t\tvec3 cube = vec3(\n\t\t\tfloor(position.x / XPERIOD),\n\t\t\tfloor(position.y / HALFYPERIOD) - 1.0,\n\t\t\t0.0);\n\n\t\tfloat opp;\n\t\tif (x < COS30) {\n\t\t\tcube.x += upper;\n\t\t\tcolor = LSHADE;\n\t\t\topp = TAN30 * (COS30 - x);\n\t\t\tif (y < opp) {\n\t\t\t\tcube.x -= upper;\n\t\t\t\tcube.y -= 1.0;\n\t\t\t}\n\t\t}\n\t\telse {\n\t\t\tcolor = RSHADE;\n\t\t\topp = TAN30 * (x - COS30);\n\t\t\tif (y < opp) {\n\t\t\t\tcube.x += 1.0-upper;\n\t\t\t\tcube.y -= 1.0;\n\t\t\t}\n\t\t}\n\t\t\n\t\tcube.x -= floor(cube.y / 2.0);\n\t\tcube.z = cubeToIdx(cube);\n\t\t\n\t\tif (cube.y < 0.0 || cube.y >= 7.0 || cube.x < 0.0 || cube.x >= 7.0 - cube.y) {\n\t\t\tcolor = vec4(0.0, 0.0, 0.0, 0.0);\n\t\t}\n\t\telse if (y < opp || opp < y-1.0) {\n\t\t\tfloat steps = stateToValues(1.0 + cube.z).r;\n\t\t\tif (steps == 2.0)\n\t\t\t\tcolor = vec4(0.0, 0.6, 0.0, 1.0);\n\t\t\telse if (steps == 1.0)\n\t\t\t\tcolor = vec4(1.0, 1.0, 0.0, 1.0);\n\t\t\telse\n\t\t\t\tcolor = vec4(0.4, 0.4, 0.7, 1.0);\n\t\t}\n\t}\n\t\n\tgl_FragColor = color;\n}", "user": "ff8d18c", "parent": "/e#1621.1", "id": 46999}