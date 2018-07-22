{"code": "// Tunnel Beauty 4 by aiekick\n// original : https://www.shadertoy.com/view/MtKGDD\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nmat3 RotZ(float a){return mat3(cos(a),-sin(a),0.,sin(a),cos(a),0.,0.,0.,1.);}\n\nvec3 path(vec3 p)\n{\n\tp *= RotZ(p.z * 0.1);\n    p += sin(p.zxy * 0.5) * 0.5;\n\tp *= RotZ(p.z * 0.2);\n   \treturn sin(p.zxy * 0.2) * 2.;\n}\n\nfloat df(vec3 p)\n{\n\tp += path(p);\n\tp *= RotZ(p.z * 0.01);\n\treturn mix(3.,2.5+3.5*sin(p.z*.5),abs(fract(atan(p.x, p.y)/3.14159*3.)-.5)) - length(p.xy);\n}\n\nvec3 nor( vec3 pos, float prec )\n{\n\tvec3 eps = vec3( prec, 0., 0. );\n\tvec3 nor = vec3(\n\t    df(pos+eps.xyy) - df(pos-eps.xyy),\n\t    df(pos+eps.yxy) - df(pos-eps.yxy),\n\t    df(pos+eps.yyx) - df(pos-eps.yyx) );\n\treturn normalize(nor);\n}\n\n// return color from temperature \n//http://www.physics.sfasu.edu/astro/color/blackbody.html\n//http://www.vendian.org/mncharity/dir3/blackbody/\n//http://www.vendian.org/mncharity/dir3/blackbody/UnstableURLs/bbr_color.html\nvec3 blackbody(float Temp)\n{\n\tvec3 col = vec3(255.);\n    col.x = 56100000. * pow(Temp,(-3. / 2.)) + 148.;\n   \tcol.y = 100.04 * log(Temp) - 623.6;\n   \tif (Temp > 6500.) col.y = 35200000. * pow(Temp,(-3. / 2.)) + 184.;\n   \tcol.z = 194.18 * log(Temp) - 1448.6;\n   \tcol = clamp(col, 0., 255.)/255.;\n    if (Temp < 1000.) col *= Temp/1000.;\n   \treturn col;\n}\n\n// get density of the df at surfPoint\n// ratio between constant step and df value\nfloat SubDensity(vec3 surfPoint, float prec, float ms) \n{\n\tvec3 n;\n\tfloat s = 0.;\n    const int iter = 3;\n\tfor (int i=0;i<iter;i++)\n\t{\n\t\tn = nor(surfPoint,prec); \n\t\tsurfPoint = surfPoint - n * ms; \n\t\ts += df(surfPoint);\n\t}\n\t\n\treturn 1.-s/(ms*float(iter)); // s < 0. => inside df\n}\n\nfloat SubDensity(vec3 p, float s) \n{\n\tvec3 n = nor(p,s); \t\t\t\t\t\t\t// precise normale at surf point\n\treturn df(p - n * s)/s;\t\t\t\t\t\t// ratio between df step and constant step\n}\n\nvoid main()\n{\n\tvec2 g = gl_FragCoord.xy;\n\tvec2 si = resolution;\n\t\n\tvec2 uv = (g+g-si)/si.y;\n\n\tfloat time = time*0.5;\n\t\n\tvec3 ro = vec3(0,0, time*5.);\n\tro -= path(ro);\n\t\n\tvec3 cv = ro + vec3(0,0,4); // cam view\n\tcv -= path(cv);\n\t\n\tvec3 lp = ro;\t// light pos\n\t\n\tvec3 cu = normalize(vec3(0,1,0));\n  \tvec3 z = normalize(cv-ro);\n    vec3 x = normalize(cross(cu,z));\n  \tvec3 y = cross(z,x);\n  \tvec3 rd = normalize(z + uv.x*x + uv.y*y);\n\n\tfloat s = 1., d = 0.;\n\tfor (int i=0; i<150; i++) \n\t{\n\t\tif (log(d*d/s/1e6)>0.) break; \n\t\td += (s = df(ro+rd*d))*0.2;\n\t}\n\t\n\tvec3 p = ro + rd * d;\t\t\t\t\t\t\t\t\t\t\t// surface point\n\tvec3 ld = normalize(lp-p); \t\t\t\t\t\t\t\t\t\t// light dir\n\tvec3 n = nor(p, 0.1);\t\t\t\t\t\t\t\t\t\t\t// normal at surface point\n\tvec3 refl = reflect(rd,n);\t\t\t\t\t\t\t\t\t\t// reflected ray dir at surf point \n\tfloat diff = clamp( dot( n, ld ), 0.0, 1.0 ); \t\t\t\t\t// diffuse\n\tfloat fre = pow( clamp( 1. + dot(n,rd),0.0,1.0), 4. ); \t\t\t// fresnel\n\tfloat spe = pow(clamp( dot( refl, ld ), 0.0, 1.0 ),16.);\t\t// specular\n\tvec3 col = vec3(0.8,0.5,0.2);\n\tfloat sss = df(p - n*0.001)/0.01;\t\t\t\t\t\t\t\t// quick sss 0.001 of subsurface\n\t\n\tfloat sb = SubDensity(p, 0.01, 0.01);\t\t\t\t\t\t\t// deep subdensity from 0.01 to 0.1 (10 iterations)\n\tvec3 bb = clamp(blackbody(100. * sb),0.,1.);\t\t\t\t\t// blackbody color\n\tfloat sss2 = 1.0 - SubDensity(p, 1.5); \t\t\t\t\t\t\t// one step sub density of df of 1.5 of subsurface\n\t\n\tvec3 a = (diff + fre + bb * sss * .8 + col * sss * .2) * 0.35 + spe;\n    vec3 b = col * sss2;\n    \n\tgl_FragColor.rgb = mix(a, b, .8-exp(-0.005*d*d));\n\tgl_FragColor.a = 1.;\n}\n\n", "user": "cd6fd27", "parent": null, "id": "36684.2"}