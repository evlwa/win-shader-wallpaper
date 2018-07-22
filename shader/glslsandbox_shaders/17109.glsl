{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nvarying vec2 surfacePosition;\n\n// Andrew Caudwell 2014\n// @acaudwell\n\n#define MAX_RAY_STEPS 96\n#define IFS_ITERATIONS 32\n\n// uncomment to see how it works ...\n//#define DEBUG\n\n// enable ray sphere intersection test\n#define INTERSECTION_TEST\n\n#define COLOUR vec3(0.55, 1.15, 0.5)\n\n#ifdef DEBUG\nvec3 col1 = vec3(1.0, 0.0, 0.0);\nvec3 col2 = vec3(0.0, 1.0, 0.0);\nvec3 col3 = vec3(0.0, 0.0, 1.0);\nvec3 col4 = vec3(1.0, 0.0, 1.0);\nvec3 col5 = vec3(0.0, 1.0, 1.0);\n#else\nvec3 col  = COLOUR;\nvec3 col1 = COLOUR;\nvec3 col2 = COLOUR;\nvec3 col3 = COLOUR;\nvec3 col4 = COLOUR;\nvec3 col5 = COLOUR;\n#endif\n\nmat4 calc_transform(vec3 offset, vec3 axis, float angle, float scale) {\n\n    angle *= radians(1.0);\n\t\n    float c = cos(angle);\n    float s = sin(angle);\n\n    vec3 t = (1.0-c) * axis;\n\n    return mat4(\n        vec4(c + t.x * axis.x, t.y * axis.x - s * axis.z, t.z * axis.x + s * axis.y, 0.0) * scale,\n        vec4(t.x * axis.y + s * axis.z, (c + t.y * axis.y),          t.z * axis.y - s * axis.x, 0.0) * scale,\n        vec4(t.x * axis.z - s * axis.y, t.y * axis.z + s * axis.x, c + t.z * axis.z, 0.0) * scale,\n        vec4(offset, 1.0)\n    );\n}\n\nmat4 M;\n\nfloat IFS(vec3 p, float s) {\n        \n\tp /= s;\n\t\n\tfor(int i=0;i<IFS_ITERATIONS;i++) {\n\t\t\n\t\tp = abs(p);\n\t\t\n\t\t// apply transform\n\t\tp = (M * vec4(p, 1.0)).xyz;                             \n\t}\n\t\n\t// divide by scale preserve correct distance\n\treturn ((length(p)-1.0) * (pow(1.5, -float(IFS_ITERATIONS))))*s;\n}\n\nvec3 dir;\n\nbool intersect(vec3 p, float r) {\n\n    float b = 2.0 * dot(dir, p);\n    float c = dot(p, p) - r*r;\n\n    float sq = sqrt(b*b - 4.0*c);\n\n    float t1 = (-b + sq) * 0.5;\n    float t2 = (-b - sq) * 0.5;\n\n    float near = min(t1, t2);\n    float far  = max(t1, t2);\n\n    return near < far && far > 0.0;\n}\n\n\nvoid combineIFS(vec3 p, float s, vec3 c, inout vec4 o) {\n\n#ifdef INTERSECTION_TEST\n    if(intersect(p, s*1.75)) {\n#endif\n\t\tfloat d = IFS(p,s);\n\t\tif(d<o.x) o = vec4(d,c);\n#ifdef INTERSECTION_TEST\n\t}\n#endif\n}\n\n#define SF 0.2023\n\nvec3 sp = normalize(vec3(1.0,1.0,-1.0));\n\nvec4 scene(vec3 p) {\n\t\n\tvec3 p2 = p - (sp + sp*SF);\n\tvec3 p3 = p - (sp + sp*SF*2.0 + sp*SF*SF);\n\tvec3 p4 = p - (sp + sp*SF*2.0 + sp*SF*SF*2.0 + sp*SF*SF*SF);\n\tvec3 p5 = p - (sp + sp*SF*2.0 + sp*SF*SF*2.0 + sp*SF*SF*SF*2.0 + sp*SF*SF*SF*SF);\n\tvec3 p6 = p - (sp + sp*SF*2.0 + sp*SF*SF*2.0 + sp*SF*SF*SF*2.0 + sp*SF*SF*SF*SF*2.0 + sp*SF*SF*SF*SF*SF);\n\t\n\tvec4 o = vec4(10000.0,vec3(0.0));\n\t\n\tcombineIFS(p,1.0,             col1, o);\n\tcombineIFS(p2,SF,             col2, o);\n\tcombineIFS(p3,SF*SF,          col3, o);\n\tcombineIFS(p4,SF*SF*SF,       col4, o);\n\tcombineIFS(p5,SF*SF*SF*SF,    col5, o);\n\t//combine(IFS(p6,SF*SF*SF*SF*SF), vec3(1.0), o);\n\t\n\treturn o;       \n}\n\nvoid main(void) {\n\n    vec2 uv = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;\n\n\tM = calc_transform(vec3(-0.4,-0.4,-0.55),normalize(vec3(1.0, 1.0, 1.0)), 40.0, 1.5);\n\n\tdir = normalize(vec3(uv.x, uv.y * (resolution.y/resolution.x), 0.665));\n\t\n\tfloat t = log(1.0 + 2.0*fract(time/19.0)) / log(3.0);\n\t\n\tvec3 t1 = sp + sp*SF*2.0 + sp*SF*SF + vec3(-0.05,-0.05,-SF);\n\tvec3 t2 = sp + sp*SF*2.0 + sp*SF*SF*2.0 + sp*SF*SF*SF + vec3(-0.05*SF,-0.05*SF,-SF*SF);\n\t\n\tvec3 cam = t1 + (t2-t1) * t;\n\t\n\tfloat d = 1.0;\n\tfloat ray_length = 0.0;\n\t\n\tint steps = 0;\n\t\n\tvec3 c = vec3(vec3(0.0, 0.55, 1.0)*(pow(length(vec2(uv.x,uv.y*2.0)),0.5)-1.05));\n\t\n\tvec4 s = vec4(0.0);\n                \n\tfor(int i=0; i<MAX_RAY_STEPS; i++) {\n\t\tif(d<0.000025) continue;\n\t\ts = scene(cam);\n\t\td = s.x;\n\t\tcam += d * dir;\n\t\tray_length += d;\n\t\tsteps++;\n\t}\n\n\tif(ray_length<1.0) {\n\t\tc = s.yzw;\n\t\t\n\t\tfloat cost = float(steps)/float(MAX_RAY_STEPS)+t*0.0225;\n\t\t\n\t\t// cost based shading\n\t\t\n\t\tc *= pow(1.0 - cost,5.0);\n\t\t\n\t\tc += pow(1.0 - cost,27.0);\n\t\t\n\t\tc += 0.08;\n\t}\n                \n    gl_FragColor = vec4(c,1.0);\n}", "user": "61e70d1", "parent": null, "id": "17109.2"}