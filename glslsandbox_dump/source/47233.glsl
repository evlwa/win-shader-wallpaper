{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nvarying vec2 surfacePosition;\n\nvoid main(void) {\n    vec2  a = mod(surfacePosition.xy + 0.5, 2.) - 1.;\n    float c = sign(a.x * a.y);\n    gl_FragColor = vec4(0., c, 0., 1.);\n}", "user": "1eca43", "parent": null, "id": 47233}