{"code": "\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n\t\nfloat sdBox( vec3 p, vec3 b )\n{\n  vec3 d = abs(p) - b;\n  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));\n}\n\nfloat sdBox( vec2 p, vec2 b )\n{\n  vec2 d = abs(p) - b;\n  return min(max(d.x,d.y),0.0) + length(max(d,0.0));\n}\n\n\nvec3 nrand3( vec2 co )\n{\n\tvec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );\n\tvec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );\n\tvec3 c = mix(a, b, 0.5);\n\treturn c;\n}\n\nfloat map(vec3 p)\n{\n    float h = 1.8;\n    float rh = 0.5;\n    float grid = 0.4;\n    float grid_half = grid*0.5;\n    float cube = 0.175;\n    vec3 orig = p;\n\n    vec3 g1 = vec3(ceil((orig.x)/grid), ceil((orig.y)/grid), ceil((orig.z)/grid));\n    vec3 rxz =  nrand3(g1.xz);\n    vec3 ryz =  nrand3(g1.yz);\n\n    p = -abs(p);\n    vec3 di = ceil(p/4.8);\n    p.y += di.x*1.0;\n    p.x += di.y*1.2;\n    p.xy = mod(p.xy, -4.8);\n\n    vec2 gap = vec2(rxz.x*rh, ryz.y*rh);\n    float d1 = p.y + h + gap.x;\n    float d2 = p.x + h + gap.y;\n\n    vec2 p1 = mod(p.xz, vec2(grid)) - vec2(grid_half);\n    float c1 = sdBox(p1,vec2(cube));\n\n    vec2 p2 = mod(p.yz, vec2(grid)) - vec2(grid_half);\n    float c2 = sdBox(p2,vec2(cube));\n\n    return max(max(c1,d1), max(c2,d2));\n}\n\n\n\nvec3 genNormal(vec3 p)\n{\n    const float d = 0.01;\n    return normalize( vec3(\n        map(p+vec3(  d,0.0,0.0))-map(p+vec3( -d,0.0,0.0)),\n        map(p+vec3(0.0,  d,0.0))-map(p+vec3(0.0, -d,0.0)),\n        map(p+vec3(0.0,0.0,  d))-map(p+vec3(0.0,0.0, -d)) ));\n}\n\nvoid main()\n{\n    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;\n    vec3 camPos = vec3(-0.5,0.0,3.0);\n    vec3 camDir = normalize(vec3(0.3, 0.0, -1.0));\n    camPos -=  vec3(0.0,0.0,time*3.0);\n    vec3 camUp  = normalize(vec3(0.5, 1.0, 0.0));\n    vec3 camSide = cross(camDir, camUp);\n    float focus = 1.8;\n\n    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);\t    \n    vec3 ray = camPos;\n    int march = 0;\n    float d = 0.0;\n\n    float total_d = 0.0;\n    const int MAX_MARCH = 64;\n    const float MAX_DIST = 100.0;\n    for(int mi=0; mi<MAX_MARCH; ++mi) {\n        d = map(ray);\n        march=mi;\n        total_d += d;\n        ray += rayDir * d;\n        if(d<0.001) {break; }\n        if(total_d>MAX_DIST) {\n            total_d = MAX_DIST;\n            march = MAX_MARCH-1;\n            break;\n        }\n    }\n\t\n    float glow = 0.0;\n    {\n        const float s = 0.0075;\n        vec3 p = ray;\n        vec3 n1 = genNormal(ray);\n        vec3 n2 = genNormal(ray+vec3(s, 0.0, 0.0));\n        vec3 n3 = genNormal(ray+vec3(0.0, s, 0.0));\n        glow = (1.0-abs(dot(camDir, n1)))*0.5;\n        if(dot(n1, n2)<0.8 || dot(n1, n3)<0.8) {\n            glow += 0.6;\n        }\n    }\n    {\n\tvec3 p = ray;\n        float grid1 = max(0.0, max((mod((p.x+p.y+p.z*2.0)-time*3.0, 5.0)-4.0)*1.5, 0.0) );\n        float grid2 = max(0.0, max((mod((p.x+p.y*2.0+p.z)-time*2.0, 7.0)-6.0)*1.2, 0.0) );\n        vec3 gp1 = abs(mod(p, vec3(0.24)));\n        vec3 gp2 = abs(mod(p, vec3(0.32)));\n        if(gp1.x<0.23 && gp1.z<0.23) {\n            grid1 = 0.0;\n        }\n        if(gp2.y<0.31 && gp2.z<0.31) {\n            grid2 = 0.0;\n        }\n        glow += grid1+grid2;\n    }\n\n    float fog = min(1.0, (1.0 / float(MAX_MARCH)) * float(march))*1.0;\n    vec3  fog2 = 0.01 * vec3(1, 1, 1.5) * total_d;\n    glow *= min(1.0, 4.0-(4.0 / float(MAX_MARCH-1)) * float(march));\n    float scanline = mod(gl_FragCoord.y, 4.0) < 2.0 ? 0.7 : 1.0;\n    gl_FragColor = vec4(vec3(0.15+glow*0.75, 0.15+glow*0.75, 0.2+glow)*fog + fog2, 1.0) * scanline;\n}\n", "user": "bd3fbb8", "parent": "/e#9413.4", "id": "10544.6"}