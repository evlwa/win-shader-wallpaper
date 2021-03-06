{"code": "#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\nuniform vec4 mouse;\n\nvoid main(void)\n{\n    vec2 p = (2.0*gl_FragCoord.xy-resolution)/resolution.y;\n\tp -= vec2(0.,0.3);\n    // animate\n    float tt = mod(time,2.0)/2.0;\n    float ss = pow(tt,.2)*0.5 + 0.5;\n    ss -= ss*0.2*sin(tt*6.2831*10.0)*exp(-tt*6.0);\n    p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);\n\n    \n    float a = atan(p.x,p.y)/3.141593;\n    float r = length(p);\n\n    // shape\n    float h = abs(a);\n    float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);\n\n    // color\n    float f = step(r,d) * pow(1.0-r/d,0.25);\n\n    gl_FragColor = vec4(f,0.,f/3.,1.0);\n}", "user": "5698279", "parent": "/e#5593.0", "id": "27499.0"}