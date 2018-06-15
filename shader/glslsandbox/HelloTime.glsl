{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nfloat SCALE = 2.0;\nvec2 SPR_SIZE = vec2(6, 8);\n\nvec2 start = vec2(0,0);\nvec2 tuv = vec2(0,0);\nvec2 chp = vec2(0,0);\nvec2 cur = vec2(0,0);\nvec2 char = vec2(0,0);\n\nvec2 c_a = vec2(0x7228BE, 0x8A2000);\nvec2 c_b = vec2(0xF22F22, 0x8BC000);\nvec2 c_c = vec2(0x722820, 0x89C000);\nvec2 c_d = vec2(0xE248A2, 0x938000);\nvec2 c_e = vec2(0xFA0E20, 0x83E000);\nvec2 c_f = vec2(0xFA0E20, 0x820000);\nvec2 c_g = vec2(0x72282E, 0x89C000);\nvec2 c_h = vec2(0x8A2FA2, 0x8A2000);\nvec2 c_i = vec2(0xF88208, 0x23E000);\nvec2 c_j = vec2(0xF84104, 0x918000);\nvec2 c_k = vec2(0x8A4A34, 0x8A2000);\nvec2 c_l = vec2(0x820820, 0x83E000);\nvec2 c_m = vec2(0x8B6AA2, 0x8A2000);\nvec2 c_n = vec2(0x8B2AA6, 0x8A2000);\nvec2 c_o = vec2(0x7228A2, 0x89C000);\nvec2 c_p = vec2(0xF228BC, 0x820000);\nvec2 c_q = vec2(0x7228AA, 0x99E000);\nvec2 c_r = vec2(0xF228BC, 0x8A2000);\nvec2 c_s = vec2(0x7A0702, 0x0BC000);\nvec2 c_t = vec2(0xF88208, 0x208000);\nvec2 c_u = vec2(0x8A28A2, 0x89C000);\nvec2 c_v = vec2(0x8A28A2, 0x508000);\nvec2 c_w = vec2(0x8A28AA, 0xDA2000);\nvec2 c_x = vec2(0x8A2722, 0x8A2000);\nvec2 c_y = vec2(0x8A2782, 0x89C000);\nvec2 c_z = vec2(0xF84210, 0x83E000);\nvec2 c_0 = vec2(0x732AA6, 0x89C000);\nvec2 c_1 = vec2(0x218208, 0x23E000);\nvec2 c_2 = vec2(0x722108, 0x43E000);\nvec2 c_3 = vec2(0x722302, 0x89C000);\nvec2 c_4 = vec2(0x92491E, 0x104000);\nvec2 c_5 = vec2(0xFA0F02, 0x89C000);\nvec2 c_6 = vec2(0x72283C, 0x89C000);\nvec2 c_7 = vec2(0xF82108, 0x420000);\nvec2 c_8 = vec2(0x722722, 0x89C000);\nvec2 c_9 = vec2(0x722782, 0x89C000);\nvec2 c_per = vec2(0x000000, 0x008000);\nvec2 c_exc = vec2(0x208208, 0x008000);\nvec2 c_com = vec2(0x000000, 0x008400);\nvec2 c_col = vec2(0x008000, 0x008000);\nvec2 c_sol = vec2(0x008000, 0x008400);\nvec2 c_pls = vec2(0x00823E, 0x208000);\nvec2 c_dsh = vec2(0x00003E, 0x000000);\nvec2 c_div = vec2(0x002108, 0x420000);\nvec2 c_ast = vec2(0x000508, 0x500000);\nvec2 c_lbr = vec2(0x084104, 0x102000);\nvec2 c_rbr = vec2(0x810410, 0x420000);\nvec2 c_lsb = vec2(0x184104, 0x106000);\nvec2 c_rsb = vec2(0xC10410, 0x430000);\nvec2 c_lcb = vec2(0x184208, 0x106000);\nvec2 c_rcb = vec2(0xC10208, 0x430000);\nvec2 c_les = vec2(0x084208, 0x102000);\nvec2 c_grt = vec2(0x408104, 0x210000);\nvec2 c_sqo = vec2(0x208000, 0x000000);\nvec2 c_dqo = vec2(0x514000, 0x000000);\nvec2 c_que = vec2(0x72208C, 0x008000);\nvec2 c_pct = vec2(0x022108, 0x422000);\nvec2 c_dol = vec2(0x21EA1C, 0x2BC200);\nvec2 c_num = vec2(0x53E514, 0xF94000);\nvec2 c_ats = vec2(0x722BAA, 0xA9C000);\nvec2 c_equ = vec2(0x000F80, 0xF80000);\nvec2 c_tdl = vec2(0x42A100, 0x000000);\nvec2 c_rsl = vec2(0x020408, 0x102000);\nvec2 c_crt = vec2(0x214880, 0x000000);\nvec2 c_amp = vec2(0x42842C, 0x99C000);\nvec2 c_bar = vec2(0x208208, 0x208208);\nvec2 c_blk = vec2(0xFFFFFF, 0xFFFFFF);\nvec2 c_trd = vec2(0xFD5FD5, 0xFD5FD5);\nvec2 c_hlf = vec2(0xA95A95, 0xA95A95);\nvec2 c_qrt = vec2(0xA80A80, 0xA80A80);\nvec2 c_spc = vec2(0x000000, 0x000000);\n\nvec2 digit(float n)\n{\n\tn = mod(floor(n),10.0);\n\tif(n == 0.0) return c_0;\n\tif(n == 1.0) return c_1;\n\tif(n == 2.0) return c_2;\n\tif(n == 3.0) return c_3;\n\tif(n == 4.0) return c_4;\n\tif(n == 5.0) return c_5;\n\tif(n == 6.0) return c_6;\n\tif(n == 7.0) return c_7;\n\tif(n == 8.0) return c_8;\n\tif(n == 9.0) return c_9;\n\treturn vec2(0.0);\n}\n\nfloat sprite(vec2 ch,vec2 uv)\n{\n\tuv = floor(uv);\n\tvec2 b = vec2((SPR_SIZE.x - uv.x - 1.0) + uv.y * SPR_SIZE.x) - vec2(24,0);\n\tvec2 p = mod(floor(ch / exp2(clamp(b,-1.0, 25.0))), 2.0);\n\treturn dot(p,vec2(1)) * float(all(bvec4(greaterThanEqual(uv,vec2(0)), lessThan(uv,SPR_SIZE))));\n}\n\nvoid ch(vec2 ch)\n{\n\tif(floor(chp) == floor(cur))\n\t{\n\t\tchar = ch;\n\t}\n\tcur.x++;\n}\n\nvoid start_print(vec2 uv)\n{\n\tcur = uv;\n\tstart = uv;\n}\n\nvoid spc()\n{\n\tcur.x++;\n}\nvoid nl()\n{\n\tcur.x = start.x;\n\tcur.y--;\n}\n\nvoid number(float n)\n{\n\tfor(int i = 5;i > -3;i--)\n\t{\n\t\tfloat d = n/pow(10.0, float(i));\n\t\tif(i == -1){ ch(c_per); }\n\t\tif(d > 1.0 || i <= 0){ ch(digit(d)); }\n\t}\t\n}\n\nvec2 str_size(vec2 cl)\n{\n\treturn SPR_SIZE * cl;\n}\n\n\n\nvoid main( void ) \n{\n\tvec2 aspect = resolution.xy / resolution.y;\n\tvec2 uv = ( gl_FragCoord.xy ) / SCALE;\n\t\n\tchp = floor(uv/SPR_SIZE);\n\tvec2 cuv = mod(uv,SPR_SIZE);\n\t\n\ttuv = floor(cuv);\n\t\n\tvec2 cen = (resolution / (SPR_SIZE * SCALE)) / 2.0;\n\t\n\tcen -= vec2(5,2)/2.0;\n\t\n\tcen.y += 1.0;\n\t\n\tcen = floor(cen);\n\t\n\tstart_print(cen);\n\t\n\tch(c_h);\n\tch(c_e);\n\tch(c_l);\n\tch(c_l);\n\tch(c_o);\n\tnl();\n\tch(c_w);\n\tch(c_o);\n\tch(c_r);\n\tch(c_l);\n\tch(c_d);\t\n\t\n\tstart_print(vec2(0,0));\n\t\n\tch(c_t);\n\tch(c_i);\n\tch(c_m);\n\tch(c_e);\n\tch(c_col);\n\t\n\tnumber(time);\n\t\n\tgl_FragColor = vec4( vec3( sprite(char,cuv) ), 1.0 );\n}", "user": "a8250a4", "parent": null, "id": "27059.10"}