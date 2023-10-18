using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using XLua;

public class Lesson2_Loader : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        LuaEnv env = new LuaEnv();

        //xlua提供的路径重定向的方法
        //允许自定义加载Lua文件
        //当我们执行Lua语言require时，相当于执行一个lua脚本
        //他会执行我们自定义传入的函数
        env.AddLoader(MyCustomLoader);

        env.DoString("require('LuaMain')");

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private byte[] MyCustomLoader(ref string filePath)
    {
        string path=Application.dataPath+"/Lua/"+filePath+".lua";
        Debug.Log(path);

        if (File.Exists(path))
        {
           return  File.ReadAllBytes(path);
        }
        else
        {
            Debug.Log("MyCustomLoader重定向路径失败，文件名：" + filePath);
        };


        return null;
    }
}
