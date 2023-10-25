using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Events;
using XLua;

[Hotfix]
public class HotfixMain : MonoBehaviour
{
    HotfixTest2 hotfixTest2;

    public int[] array=new int[] { 1, 2, 3 };
    public int Age
    {
        get
        {
            return 0;
        }
        set
        {
            Debug.Log(value);
        }
    }

    public int this[int index]
    {
        get
        {
            if (index < 0||index>=array.Length)
            {
                Debug.LogWarning("索引不正确");
                return 0;
            }
            return array[index];
        }
        set
        {
            if (index < 0 || index >= array.Length)
            {
                Debug.LogWarning("索引不正确");
                return;
            }
             array[index]= value;

        }
    }


    event UnityAction myEvent;

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

        //hotfixTest2 =new HotfixTest2();
        //hotfixTest2.Speak("Start");

        //StartCoroutine(TestCoroutine());


        this.Age= 10;
        Debug.Log(this.Age);

        this[0] = 100;
        Debug.Log(this[0]);

        myEvent += TestEvent;
        myEvent -= TestEvent;

        HotfixGenericity<string> t1=new HotfixGenericity<string>();
        t1.Test("321");

        HotfixGenericity<int> t2=new HotfixGenericity<int>();
        t2.Test(123);
    }

    private void TestEvent()
    {

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
[Hotfix]
public class HotfixGenericity<T>
{
    public void Test(T t)
    {
        Debug.Log(t);
    }
}