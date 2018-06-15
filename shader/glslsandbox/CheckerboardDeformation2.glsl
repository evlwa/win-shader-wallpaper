{"code": "precision mediump float;\nuniform float time;\nuniform vec2 resolution;\nvoid main( void ) {\n\tvec2 p = gl_FragCoord.xy - resolution.xy * 0.5;\n\tfloat t = time + length(p / 8.0) / 3700. * time;\n\tvec2 rot = vec2(cos(t) * p.x - sin(t) * p.y,\n\t\t \tcos(t) * p.y + sin(t) * p.x) / 0.2*cos(t*3.0)/500.0;\n\tif (fract(rot.x) > .5 ^^ fract(rot.y) > .5) {\n\tgl_FragColor = vec4(1.0);\n\t} else {\n\tgl_FragColor = vec4(sin(time),cos(time / 2.0),cos(time),0.0);\n\t}\n}", "user": "9819790", "parent": "/e#24250.0", "id": "27365.0"}