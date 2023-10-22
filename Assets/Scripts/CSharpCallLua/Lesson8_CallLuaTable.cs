using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

public class Lesson8_CallLuaTable : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        LuaMgr.GetInstance().Init();
        LuaMgr.GetInstance().DoLuaFile("LuaMain");

        LuaTable table = LuaMgr.GetInstance().Global.Get<LuaTable>("testClass");

        print(table.Get<int>("testInt") + "     " + table.Get<bool>("testBool") + "        " + table.Get<float>("testFloat") + "        " + table.Get<string>("testString") + "  ");

        table.Get<LuaFunction>("testFun").Call();

        //效率低，是引用对象

        table.Dispose();

        //CSharpCallLua特性在自定义委托和接口才用
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
