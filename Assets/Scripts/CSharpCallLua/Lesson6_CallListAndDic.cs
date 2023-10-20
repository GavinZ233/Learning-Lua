using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson6_CallListAndDic : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        LuaMgr.GetInstance().Init();
        LuaMgr.GetInstance().DoLuaFile("LuaMain");

        //同一类型List
        List<int> list = LuaMgr.GetInstance().Global.Get<List<int>>("testList");
        for(int i = 0; i < list.Count; i++)
        {
            print(list[i]);
        }

        list[0] = 100;
        List<int> list2 = LuaMgr.GetInstance().Global.Get<List<int>>("testList");
        print(list2[0]);
        //没有修改到lua中的数据，是深拷贝


        //用obj装内容
        List<object> list3 = LuaMgr.GetInstance().Global.Get<List<object>>("testArray");
        for (int i = 0; i < list3.Count; i++)
        {
            print(list3[i]);
        }

        //字典

        Dictionary<string, int> dic = LuaMgr.GetInstance().Global.Get<Dictionary<string, int>>("testDic");
        foreach (string item in dic.Keys)
        {
            print(item + "   " + dic[item]);
        }

        //obj装内容
        Dictionary<object, object> dic2 = LuaMgr.GetInstance().Global.Get<Dictionary<object, object>>("testDic2");
        foreach (var item in dic2.Keys)
        {
            print(item + "   " + dic2[item]);
        }


    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
