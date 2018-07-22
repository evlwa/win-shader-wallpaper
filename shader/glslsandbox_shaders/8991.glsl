{"code": "\n// See http://www.iquilezles.org/articles/menger/menger.htm for the\n// full explanation of how this was done\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform vec2 resolution;\nuniform float time;\n\nfloat maxcomp(in vec3 p ) { return max(p.x,max(p.y,p.z));}\nfloat sdBox( vec3 p, vec3 b )\n{\n  vec3  di = abs(p) - b;\n  float mc = maxcomp(di);\n  return min(mc,length(max(di,0.0)));\n}\n\nfloat sdSphere( vec3 p, float s )\n{\n  return length(p)-s;\n} \n\nfloat sdTorus( vec3 p, vec2 t )\n{\n  vec2 q = vec2(length(p.xz)-t.x,p.y);\n  return length(q)-t.y;\n}\n\nvec4 map( in vec3 p )\n{\n   //float d = sdBox(p,vec3(1.0));\n   //float d = sdSphere(p, 1.4);\n   float d = sdTorus(p, vec2(1.0));\n   vec4 res = vec4( d, 1.0, 0.0, 0.0 );\n\n   float s = 1.0;\n   for( int m=0; m<5; m++ )\n   {\n      vec3 a = mod( p*s, 2.0 )-1.0;\n      s *= 3.0;\n      vec3 r = abs(1.0 - 3.0*abs(a));\n\n      float da = max(r.x,r.y);\n      float db = max(r.y,r.z);\n      float dc = max(r.z,r.x);\n      float c = (min(da,min(db,dc))-1.0)/s;\n\t   \n      //float c = (length(r)-1.0)/s;\n\n      if( c>d )\n      {\n          d = c;\n          res = vec4( d, 0.2*da*db*dc, (1.0+float(m))/4.0, 0.0 );\n       }\n   }\n\n   return res;\n}\n\nvec4 intersect( in vec3 ro, in vec3 rd )\n{\n    float t = 0.0;\n    for(int i=0;i<128;i++)\n    {\n        vec4 h = map(ro + rd*t);\n        if( h.x<0.002 )\n            return vec4(t,h.yzw);\n        t += h.x;\n    }\n    return vec4(-1.0);\n}\n\nvec3 calcNormal(in vec3 pos)\n{\n    vec3  eps = vec3(.001,0.0,0.0);\n    float d = map(pos).x;\n    vec3 nor;\n    nor.x = d-map(pos-eps.xyy).x;\n    nor.y = d-map(pos-eps.yxy).x;\n    nor.z = d-map(pos-eps.yyx).x;\n    return normalize(nor);\n}\n\nvoid main(void)\n{\n    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;\n    p.x *= 1.33;\n\n    // light\n    vec3 light = normalize(vec3(1.0,0.8,-0.6));\n\n    float ctime = time;\n    // camera\n    vec3 ro = 1.1*vec3(2.5*cos(0.5*ctime),1.5*cos(ctime*.23),2.5*sin(0.5*ctime));\n    vec3 ww = normalize(vec3(0.0) - ro);\n    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));\n    vec3 vv = normalize(cross(ww,uu));\n    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );\n\n    vec3 col = vec3(0.0);\n    vec4 tmat = intersect(ro,rd);\n    if( tmat.x>0.0 )\n    {\n        vec3 pos = ro + tmat.x*rd;\n        vec3 nor = calcNormal(pos);\n\n        float dif1 = max(dot(nor,light),0.0);\n        float dif2 = max(0.4 + 0.6*dot(nor,vec3(-light.x,light.y,-light.z)),0.0);\n\n        // shadow\n        float ldis = 4.0;\n        vec4 shadow = intersect( pos + light*ldis, -light );\n        if( shadow.x>0.0 && shadow.x<(ldis-0.01) ) dif1=0.0;\n\n        float ao = tmat.y;\n        col  = 1.0*ao*vec3(0.2,0.2,0.2);\n        col += 2.0*(0.5+0.5*ao)*dif1*vec3(1.0,0.97,0.85);\n        col += 0.3*(0.5+0.5*ao)*dif2*vec3(1.0,0.97,0.85);\n        col += 1.0*(0.5+0.5*ao)*(0.5+0.5*nor.y)*vec3(0.1,0.15,0.2);\n    }\n\n\n    gl_FragColor = vec4(col,1.0);\n}\n", "user": "698ab4e", "parent": "/e#6722.0", "id": "8991.0"}