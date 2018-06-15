{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/XdcfR8\n */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\nconst vec3 iMouse = vec3(0.);\n\n// --------[ Original ShaderToy begins here ]---------- //\n#define PI 3.14159265359\n#define rot(a) mat2(cos(a+PI*vec4(0,1.5,0.5,0)))\n#define SCALE 4.0\n#define FOV 1.0\n\n//f (x)=sin(a*x)*b\n//f'(x)=a*b*cos(a*x)\n#define PATHA vec2(0.1147, 0.2093)\n#define PATHB vec2(13.0, 3.0)\nvec3 camPath( float z ) {\n    return vec3(sin(z*PATHA)*PATHB, z);\n}\nvec3 camPathDeriv( float z ) {\n    return vec3(PATHA*PATHB*cos(PATHA*z), 1.0);\n}\n\nfloat sdBox( in vec3 p, in vec3 b, in float r, out vec3 color ) {\n   \tvec3 d = abs(p) - b;\n    color = normalize(smoothstep(vec3(-r), vec3(0.0), d));\n\treturn min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));\n}\n\nfloat de( in vec3 p, in float r, out vec3 color ) {\n    \n    // wrap world around camera path\n    vec3 wrap = camPath(p.z);\n    vec3 wrapDeriv = normalize(camPathDeriv(p.z));\n    p.xy -= wrap.xy;\n    p -= wrapDeriv*dot(vec3(p.xy, 0), wrapDeriv)*0.5*vec3(1,1,-1);\n    \n    // change the fractal rotation along an axis\n    float q=p.z*0.074;\n    \n    // accumulate scale and distance\n    float s = 1.0;\n    float d = 9e9;\n    \n    // accumulate color\n    vec3 albedo = vec3(0);\n    float colorAcc = 0.0;\n    \n    for (float i = 0.5 ; i < 4.0 ; i += 1.14124) {\n        p.xy *= rot(-i*1.5*q);\n        p.xyz = p.zxy;\n        p.xy = abs(fract(p.xy)*SCALE-SCALE*0.5);\n        p.z *= SCALE;\n        \n        s /= SCALE;\n        \n        vec3 cube = vec3(0);\n        float dist = sdBox(p, vec3(1.07, 0.54+i*0.5, 4.47+i*0.1), r, cube)*s;\n        float co = cube.x*0.2+cube.y*0.4+cube.z*0.8;\n        vec3 col = clamp(vec3(co*i*0.1), vec3(0), vec3(0.6));\n        \n        float alpha = max(0.001, smoothstep(r, -r, dist));\n        albedo += col*alpha;\n        colorAcc += alpha;\n\n        if (i < 2.0) {\n        \td = min(d, dist);\n        } else {\n            d = max(d,-dist);\n        }\n    }\n    \n    color = albedo/colorAcc;\n    \n    return d;\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord ) {\n    \n    float z = iTime*1.0;\n    vec3 from = camPath(z);\n    vec2 uv = (fragCoord - iResolution.xy*0.5)/iResolution.y;\n    vec3 forward = normalize(camPathDeriv(z));\n    vec3 right = normalize(cross(forward, vec3(0, 1, 0)));\n    vec3 up = cross(right, forward);\n    vec3 dir = normalize(forward/tan(FOV*0.5)+right*uv.x+up*uv.y);\n    \n    if (iMouse.z > 0.5) {\n        dir.yz *= rot((iMouse.y-iResolution.y*0.5)*0.01);\n        dir.xz *= rot((iMouse.x-iResolution.x*0.5)*-0.01);\n    }\n    \n   \t// get the sine of the angular extent of a pixel\n    float sinPix = sin(FOV / iResolution.y);\n    // accumulate color front to back\n    vec4 acc = vec4(0, 0, 0, 1);\n\n    float totdist = 0.0;\n    for (int i = 0 ; i < 100 ; i++) {\n\t\tvec3 p = from + totdist * dir;\n        float r = totdist*sinPix;\n        vec3 color = vec3(1);\n        float dist = de(p, r, color);\n        \n        // compute color\n        float ao = 1.0 - float(i)/100.0;\n        color *= ao*ao;\n        \n        // cone trace the surface\n        float prox = dist / r;\n        float alpha = clamp(prox * -0.5 + 0.5, 0.0, 1.0);\n\n        // accumulate color\n        acc.rgb += acc.a * (alpha*color.rgb);\n        acc.a *= (1.0 - alpha);\n        \n        // hit a surface, stop\n        if (acc.a < 0.01) {\n            break;\n        }\n        \n        // continue forward\n        totdist += abs(dist*0.9);\n\t}\n    \n    // add fog\n    fragColor.rgb = clamp(acc.rgb, vec3(0), vec3(1));\n    float fog = clamp(totdist/20.0, 0.0, 1.0);\n    fragColor.rgb = mix(fragColor.rgb, vec3(0.4, 0.5, 0.7), fog);\n    // gamma correction\n    fragColor.rgb = pow(fragColor.rgb, vec3(1.0/2.2));\n    // vignetting\n    vec2 vig = fragCoord/iResolution.xy*2.0-1.0;\n    fragColor.rgb = mix(fragColor.rgb, vec3(0), dot(vig, vig)*0.2);\n    \n\tfragColor.a = 1.0;\n}\n// --------[ Original ShaderToy ends here ]---------- //\n\nvoid main(void)\n{\n    iTime = time;\n    iResolution = vec3(resolution, 0.0);\n\n    mainImage(gl_FragColor, gl_FragCoord.xy);\n}", "user": "c9fc3fa", "parent": null, "id": "46536.0"}