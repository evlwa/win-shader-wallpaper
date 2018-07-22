{"code": "//CLEANCODE\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst vec4  kRGBToYPrime = vec4 (0.299, 0.587, 0.114, 0.0);\nconst vec4  kRGBToI     = vec4 (0.596, -0.275, -0.321, 0.0);\nconst vec4  kRGBToQ     = vec4 (0.212, -0.523, 0.311, 0.0);\n\nconst vec4  kYIQToR   = vec4 (1.0, 0.956, 0.621, 0.0);\nconst vec4  kYIQToG   = vec4 (1.0, -0.272, -0.647, 0.0);\nconst vec4  kYIQToB   = vec4 (1.0, -1.107, 1.704, 0.0);\n\nvarying vec4 vertTexCoord;\nuniform sampler2D texture;\nuniform float hue;\n\n\nvoid main( void ) {\n\tvec2 texCoord = (gl_FragCoord.xy / resolution.xy+0.15);\n\ttexCoord += sin(texCoord.x * 6. +time) *0.1;\n\ttexCoord += sin(texCoord.y * 0.01 +time) *0.001;\n\t\n\tfor(float f = 0.0; f < 1000.0; f+=0.1) {\n\t\tif(texCoord.y > f/1000.0) {\n\t\t\tgl_FragColor = vec4(cos((1000.0-f)/1000.0), tan((1000.0-f)/1000.0), cos((1000.0-f)/1000.0), 1.0/time);\n\t\t}\n\t}\n}", "user": "230f877", "parent": null, "id": 47301}