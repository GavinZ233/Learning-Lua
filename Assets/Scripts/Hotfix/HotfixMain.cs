using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

[Hotfix]
public class HotfixMain : MonoBehaviour
{
    HotfixTest2 hotfixTest2;
    // Start is called before the first frame update
    void Start()
    {
        LuaMgr.GetInstance().Init();
        LuaMgr.GetInstance().DoLuaFile("HotfixMain");


        print("返回结果："+Add(10, 20));
        Speak("测试文本");

        //HotfixTest hotfixTest = new HotfixTest();
        //print(hotfixTest.GetAge());
        //HotfixTest1 hotfixTest1 = new HotfixTest1();
        //print(hotfixTest1.GetAge());

        hotfixTest2 =new HotfixTest2();
        hotfixTest2.Speak("Start");

        StartCoroutine(TestCoroutine());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator TestCoroutine()
    {
        while (true)
        {
            yield return new WaitForSeconds(1);
            Debug.Log("C#协程打印");
        }
    }

    public int Add(int a,int b)
    {
        return 0;
    }

    public static void Speak(string str)
    {
        Debug.Log("Speak");
    }
}
[Hotfix]
public class HotfixTest
{
    public int age=33;
    public int GetAge()
    {
        return 0;
    }
}


[Hotfix]
public class HotfixTest1
{
    public int age = 33;
    public int GetAge()
    {
        return 0;
    }
}
[Hotfix]

public class HotfixTest2
{
    public HotfixTest2()
    {
        Debug.Log("HotfixTest2构造函数");
    }

    public void Speak(string str)
    {
        Debug.Log(str);
    }

    ~HotfixTest2 () { }

}