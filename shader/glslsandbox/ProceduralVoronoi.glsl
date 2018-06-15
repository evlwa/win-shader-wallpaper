{"code": "// Procedural Tiles // Based on http://www.iquilezles.org/www/articles/smoothvoronoi/smoothvoronoi.htm\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform vec2 mouse;\nuniform vec2 resolution;\nuniform float time;\n\n// Expensive Noise\n\nvec4 textureRND2D(vec2 uv){\n\tuv = floor(fract(uv)*1e3);\n\tfloat v = uv.x+uv.y*1e3;\n\treturn fract(1e5*sin(vec4(v*1e-2, (v+1.)*1e-2, (v+1e3)*1e-2, (v+1e3+1.)*1e-2)));\n}\n\nfloat noise(vec2 p) {\n\tvec2 f = fract(p*1e3);\n\tvec4 r = textureRND2D(p);\n\tf = f*f*(3.0-2.0*f);\n\treturn (mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y));\t\n}\n\nvec2 random2f( vec2 seed ) {\n\t#define rnd_seed 1.337\n\tfloat rnd1 = mod(noise(seed*rnd_seed), 1.0);\n\tfloat rnd2 = mod(rnd1*2.0,1.0);\n\t\n\treturn vec2(rnd1, rnd2);\n}\n\n// Cheap Noise\n\nfloat rand(vec2 co){\n    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);\n}\n\nvec2 rand3(vec2 co){\n\tfloat rnd1 = rand(co);\n\tfloat rnd2 = rand(co*rnd1);\n\treturn vec2(rnd1,rnd2);\n}\n\n// Cheapest\nvec2 rand2( vec2 seed ) {\n\tfloat t = sin(seed.x+seed.y*1e3);\n\treturn vec2(fract(t*1e4), fract(t*1e6));\n}\n\n// Methods\n\nvec3 tile_color = vec3(0.0);\n\n#define tile_height 0.35\nfloat voronoi( in vec2 x ) {\n\tvec2 p = floor( x );\n\tvec2 f = fract( x );\n\t\n\tvec3 res = vec3(1.0);\n\t\n\tfor( int j=-1; j<=1; j++ ) for( int i=-1; i<=1; i++ ) {\n\t\tvec2 b = vec2( i, j );\n\t\tvec2 r = vec2( b ) + rand2( p + b ) - f; // cheap\n\t\t//vec2 r = vec2( b ) + random2f( p + b ) - f; // expensive but has some nicer properties for morphing\n\t\tfloat d = dot( r , r );\n\t\t\n\t\tif ( d < res.x ) {\n\t\t\tres.xyz = vec3(d,res.xy);\n\t\t\tif (rand(p+b) < 0.5) tile_color = vec3(.77,.87,.9);\n\t\t\telse tile_color = vec3(0.9,0.9,0.9);\n\t\t} else if (d < res.y) {\n\t\t\tres.yz = vec2(d,res.y);\n\t\t}\n    \t}\n\t\n\treturn clamp(sqrt(res.y) - sqrt(res.x),0.0,tile_height);\n}\n\nvec3 normal(vec2 p) {\n\tfloat d = 0.001;\n\tfloat d2 = 0.1; // Smoothing parameter for normal\n\tvec3 dx = vec3(d2, 0.0, voronoi(p + vec2(d2, 0.0))) - vec3(-d, 0.0, voronoi(p + vec2(-d, 0.0)));\n\tvec3 dy = vec3(0.0, d2, voronoi(p + vec2(0.0, d2))) - vec3(0.0, -d, voronoi(p + vec2(0.0, -d)));\n\treturn normalize(cross(dx,dy));\n}\n\nvoid main( void ) {\n\n\tvec2 p = vec2(sin(time*0.1),-cos(time*0.1)) + (1.*gl_FragCoord.xy)/resolution.y;\n\t\n\tfloat color = voronoi(p);\n\t\n\tfloat light_intensity = 0.75/tile_height;\n\tvec3 light = normalize(vec3(sin(time*0.1),cos(time*0.1),1.0)) * light_intensity;\n\t\n\t\n\tvec3 n = normal(p);\n\tfloat s = 2., inv = 1.;\n\tvec2 os = vec2(0.01, 0.01);\n\tfor(int i=0; i<3; i++){\n\t\tn = n + normal(p*s + os)*inv;\n\t\tcolor += voronoi(p*s+os+n.xy*0.2);\n\t\ts *= s;\n\t\tos += os;\n\t\tinv*=-1.;\n\t}\n\tn = normalize(vec3(n.xy, 1.));\n\tcolor /= 4.;\n\tfloat shade = dot(light,n)+0.5;\n\tgl_FragColor = vec4(vec3(shade*color) * tile_color, 1.0);\n}\n\n\n\n\n\n\n\n\n\n\n", "user": "e2bc64", "parent": "/e#5874.0", "id": "5882.0"}