{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n//almost\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n#define LEVELS 5\n\nvec3 \tbarycentric(vec2 uv, float scale);\nvec2 \tcartesian(vec3 uvw, float scale);\n\nvec2 \tface_index(vec2 face, float power);\nfloat \tface_address(vec2 face, float power);\nfloat \tprint_face_address(float address, vec2 position);\nfloat \tprint_face_index(vec2 index, vec2 position);\n\n//lifted from http://glslsandbox.com/e#27090.0\nfloat \textract_bit(float n, float b);\nfloat \tsprite(float n, vec2 p);\nfloat \tdigit(float n, vec2 p);\t\n\nvoid main( void ) \n{\n\tvec2 uv\t\t= gl_FragCoord.xy/resolution.xy;\n\t\n\n\tfloat text\t= 0.;\n\tfloat hilight \t= 0.;\n\tfloat address\t= 0.;\n\tfloat grid\t= 0.;\n\tvec2 face\t= vec2(0.);\n\tfloat levels\t= float(LEVELS);\t\n\n\tfor(int i = 0; i < LEVELS; i++)\n\t{\n\t\tfloat level\t\t= float(i);\n\t\tfloat power\t\t= pow(2., level);\n\t\t\n\t\tvec3 uvw\t\t= barycentric(uv, power);\n\t\tvec3 m_uvw\t\t= barycentric(mouse, power);\n\n\t\tvec2 uv_face\t\t= cartesian(floor(uvw), power);\n\t\tvec2 m_face\t\t= cartesian(floor(m_uvw), power);\n\t\n\t\tbool mouse_over\t\t= uv_face == m_face;\n\t\n\t\tfloat width\t\t= .00125*power/2.;\n\t\tgrid\t\t\t+= float(fract(uvw.x) < width || fract(uvw.y) < width || fract(uvw.z) < width) * 1./levels;\n\t\n\t\t\n\t\tvec2 uv_index\t\t= face_index(uv_face, power);\n\t\tfloat uv_address\t= face_address(uv_face, power);\n\t\t\n\t\tvec2 m_index\t\t= face_index(m_face, power);\n\t\tfloat m_address\t\t= face_address(m_face, power);\n\t\t\n\t\t\n\t\tvec2 position\t\t= vec2(0.);\n\t\t\n\t\ttext *= 0.;\n\t\tif(mouse_over)\n\t\t{\n\t\t\tposition \t= floor(gl_FragCoord.xy-m_face*resolution);\n\t\t\t//text\t \t*= 0.;\t\n\t\t\t\n\t\t\ttext \t\t-= print_face_index(m_index, position);\n\t\t\t\n\t\t\thilight\t\t+= 1./levels;\n\t\t}\n\t\telse\n\t\t{\n\t\t\tposition\t= floor(gl_FragCoord.xy-uv_face*resolution);\n\t\t\tposition.x\t-= 10.;\n\t\t\tposition.y\t+= level;\n\t\n\t\t\ttext \t\t+= print_face_address(uv_address, position);\t\n\t\t}\n\t\n\t\n\t\t//if(floor(gl_FragCoord.x) == floor(m_address*power+power * 3.))\n\t\tif(floor(gl_FragCoord.y) <= floor(m_address*power) && floor(levels-gl_FragCoord.x/16.) == floor(level))\t\n\t\t//if(floor(gl_FragCoord.xy) == floor(m_index*power))\t\n\t\t{\n\t\t\taddress \t= 0.;\n\t\t\taddress \t+= 1.;\n\t\t\taddress\t\t-= float(mod(floor(gl_FragCoord.y), power)==0.);\n\t\t}\n\t\t\n\t\t\n\t\tface\t\t\t+= uv_face/levels;\n\t}\n\t\n\tvec4 result \t= vec4(0.);\n\tresult.xy\t+= face;\n\tresult.z\t+= hilight;\n\tresult \t\t+= address\t* .25;\n\tresult\t\t+= text \t* .25;\n\tresult \t\t-= grid \t* .25;\n\tgl_FragColor \t= result;\n} // sphinx \n\nvec3 barycentric(vec2 uv, float scale)\n{\n\tuv \t\t*= scale;\t\t\n\tuv.x \t\t*= 1.5;\t\n\tuv.y\t\t/= 2.;\n\t\n\tvec3 uvw\t= vec3(0.);\n\tuvw.y\t\t=  uv.x - uv.y;\n\tuvw.z\t\t=    uv.y * 2.;\n\tuvw.x\t\t=-(uv.x + uv.y);\n\t\n\tvec3 index\t= floor(uvw);\n\tbool parity \t= mod(index.x, 2.) == 0. ^^ mod(index.y, 2.) == 0. ^^ mod(index.z, 2.) == 0.;\n\tuvw \t\t= parity ? 1.-uvw.yzx : uvw;\n\t\n\treturn\tuvw;\n}\n\nvec2 cartesian(vec3 uvw, float scale)\n{\n\tvec3 index\t= floor(uvw);\n\tbool parity \t= mod(index.x, 2.) == 0. ^^ mod(index.y, 2.) == 0. ^^ mod(index.z, 2.) == 0.;\n\tuvw \t\t= parity ? 1.-uvw.zxy : uvw;\n\t\n\tuvw.yx \t\t-= uvw.z;\n\n\tvec2 uv \t= vec2(0.);\t\t\n\tuv.x \t\t=  uvw.y - uvw.x;\n\tuv.y\t\t= -uvw.y - uvw.x;\t\n\tuv\t\t/= 3.;\n\tuv \t\t/= scale;\n\t\n\treturn uv;\n}\n\n\nvec2 face_index(vec2 face, float power)\n{\n\tvec2 index\t= vec2(0.);\n\tindex.x\t\t= floor(face.x * power * 3.);\n\tindex.y\t\t= floor(face.y * power);\n\t\n\treturn index;\n}\n\nfloat face_address(vec2 face, float power)\n{\n\tvec2 index\t= face_index(face, power); \n\treturn index.x + index.y * power * 3. + index.y;\n}\n\nfloat print_face_address(float address, vec2 position)\n{\t\n\tfloat offset\t= 4.;\n\t\n\tfloat text\t= 0.;\n\tfor(int i = 0; i < 3; i++)\n\t{\n\t\tfloat place\t= pow(10., float(i));\n\t\t\n\t\ttext\t \t+= digit(address/place, position + vec2(8., 0.));\n\t\t\n\t\tposition.x \t+= offset;\n\t}\n\treturn text;\n}\n\nfloat print_face_index(vec2 index, vec2 position)\n{\n\tfloat offset\t= 4.;\n\n\tfloat text\t= 0.;\n\tfor(int i = 0; i < 2; i++)\n\t{\n\t\tfloat place\t= pow(10., float(i));\n\t\t\t\n\t\ttext\t\t+= digit(index.x/place, position + vec2(6., 0.));\n\t\ttext\t\t+= digit(index.y/place, position + vec2(-6., 0.));\n\t\t\n\t\tposition.x \t+= offset;\n\t}\n\t\n\treturn text;\n}\n\nfloat extract_bit(float n, float b)\n{\n\tn = floor(n);\n\tb = floor(b);\n\tb = floor(n/pow(2.,b));\n\treturn float(mod(b,2.) == 1.);\n}\n\nfloat sprite(float n, vec2 p)\n{\n\tp = floor(p);\n\tfloat bounds = float(all(lessThan(p, vec2(3., 5.))) && all(greaterThanEqual(p,vec2(0,0))));\n\treturn extract_bit(n, (2. - p.x) + 3. * p.y) * bounds;\n}\n\nfloat digit(float n, vec2 p)\n{\n\tn = mod(floor(n), 10.0);\n\tif(n == 0.) return sprite(31599., p);\n\telse if(n == 1.) return sprite( 9362., p);\n\telse if(n == 2.) return sprite(29671., p);\n\telse if(n == 3.) return sprite(29391., p);\n\telse if(n == 4.) return sprite(23497., p);\n\telse if(n == 5.) return sprite(31183., p);\n\telse if(n == 6.) return sprite(31215., p);\n\telse if(n == 7.) return sprite(29257., p);\n\telse if(n == 8.) return sprite(31727., p);\n\telse if(n == 9.) return sprite(31695., p);\n\telse return 0.0;\n}", "user": "5d274ec", "parent": null, "id": "28027.5"}