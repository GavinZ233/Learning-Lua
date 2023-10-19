using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson4_CallVariable : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        LuaMgr.GetInstance().Init();
        LuaMgr.GetInstance().DoLuaFile("LuaMain");

        int i = LuaMgr.GetInstance().Global.Get<int>("testNumber");
        Debug.Log(i);

        double d = LuaMgr.GetInstance().Global.Get<double>("testNumber");
        Debug.Log(d);

        string s = LuaMgr.GetInstance().Global.Get<string>("testString");
        Debug.Log(s);

        LuaMgr.GetInstance().Global.Set("testNumber", 66);
        Debug.Log(LuaMgr.GetInstance().Global.Get<int>("testNumber"));


        LuaMgr.GetInstance().Global.Set("testString", "修改了string");
        Debug.Log(s);

        Debug.Log(LuaMgr.GetInstance().Global.Get<string>("testString"));


        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
