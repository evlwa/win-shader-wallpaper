{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nfloat circle(float x, float y) {\n\treturn length(vec2(x,y));\n}\n\nfloat square(float x, float y) {\n\treturn max(abs(x),abs(y));\n}\n\nfloat thin_line(float f) {\n\treturn f>0.48 && f<0.5?1.0:0.;\n}\n\nfloat filled(float f) {\n\treturn f<0.5?1.0:0.;\n}\n\n\nvoid main( void ) {\n\tfloat t;\n\tt = time;\n\t//t = mouse.x*10.0;\n\n\tvec2 p = ( gl_FragCoord.xy / resolution.xy );\n\t\n\tp.y*=resolution.y/resolution.x;\n\n\n\tvec3 black = vec3(0);\n\tvec3 white = vec3(1);\n\tvec3 brown = vec3(0.5,0.4,0.2);\n\tvec3 green = vec3(.2,.4,.2);\n\n\n\tfloat count = 5.;//(1.+sin(t))*.5*30.0+1.;\n\tfloat x = fract(p.x*count);\n\tfloat y = fract(p.y*count);\n\tx*=2.0;\n\ty*=2.0;\n\tx-=1.0;\n\ty-=1.0;\n\n\n\tfloat f = filled(circle(x,y));\n\n\tvec3 a,b,c,d, non_animated, animated;\n\ta = mix(black, white, f);\n\tb = mix(green, brown, f);\n\tanimated=mix(a,b,abs(sin(p.x*100.0+t)));\n\tnon_animated=mix(a,b,abs(sin(p.x*10.0)));\n\t\n\td=mix(non_animated,animated,f);\n\t\n\tc=d;\n\n\tgl_FragColor = vec4( c, 1.0 );\n\n}", "user": "d1ec84f", "parent": null, "id": 47378}