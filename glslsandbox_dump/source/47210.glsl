{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/MlfXzN\n */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\n\n// shadertoy globals\n#define iTime time\n#define iResolution resolution\n\n// --------[ Original ShaderToy begins here ]---------- //\n// Author @patriciogv - 2015\n// http://patriciogonzalezvivo.com\n\nfloat random(in float x){\n    return fract(sin(x)*43758.5453);\n}\n\nfloat random(in vec2 st){\n    return fract(sin(dot(st.xy ,vec2(12.9898,78.233))) * 43758.5453);\n}\n\nfloat randomChar(in vec2 outer,in vec2 inner){\n    float grid = 5.;\n    vec2 margin = vec2(.2,.05);\n    float seed = 23.;\n    vec2 borders = step(margin,inner)*step(margin,1.-inner);\n    return step(.5,random(outer*seed+floor(inner*grid))) * borders.x * borders.y;\n}\n\nvec3 matrix(in vec2 st){\n    float rows = 50.0;\n    vec2 ipos = floor(st*rows)+vec2(1.,0.);\n\n    ipos += vec2(.0,floor(iTime*20.*random(ipos.x)));\n\n    vec2 fpos = fract(st*rows);\n    vec2 center = (.5-fpos);\n\n    float pct = random(ipos);\n    float glow = (1.-dot(center,center)*3.)*2.0;\n\n    return vec3(randomChar(ipos,fpos) * pct * glow);\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord ){\n\tvec2 st = fragCoord.xy / iResolution.xy;\n    st.y *= iResolution.y/iResolution.x;\n\n\tfragColor = vec4(matrix(st),1.0);\n}\n// --------[ Original ShaderToy ends here ]---------- //\n\nvoid main(void)\n{\n    mainImage(gl_FragColor, gl_FragCoord.xy);\n}", "user": "8ae668d", "parent": null, "id": 47210}