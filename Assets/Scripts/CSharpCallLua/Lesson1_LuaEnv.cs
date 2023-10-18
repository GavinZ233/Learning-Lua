using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;



public class Lesson1_LuaEnv : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {   
        //解析器
        LuaEnv luaEnv = new LuaEnv();
        //执行lua语言
        luaEnv.DoString("print('嗨，你好')", "报错内容："+this.name);


        //默认寻找脚本的路径是在Resources下
        //大致是通过Resources.Load加载txt等
        //因此Lua脚本后缀要加txt
        luaEnv.DoString("require('Lua/A')");



        //帮助我们清除Lua中没有手动释放的对象  垃圾回收
        //帧更新中定时执行或者且场景执行
        luaEnv.Tick();

        //销毁Lua解析器
        luaEnv.Dispose();
        //一般情况会保证解析器的唯一性，也不会关闭解析器


    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
