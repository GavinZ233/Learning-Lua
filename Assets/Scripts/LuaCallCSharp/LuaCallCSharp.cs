using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using XLua;

public class LuaCallCSharp : MonoBehaviour
{
    void Start()
    {


    }

}
#region 调用泛型方法

public class Lesson12
{
    public interface ITest
    { }
    public class TestFather
    {

    }
    public class TestChild:TestFather,ITest 
    { }
    public void TestFun1<T>(T a, T b)where T : TestFather 
    {
        Debug.Log("有参数有约束的泛型方法");
    }

    public void TestFun2<T>(T a)
    {
        Debug.Log("有参数没约束");
    }

    public void TestFun3<T>() where T : TestFather
    {
        Debug.Log("有参数有约束的泛型方法");
    }

    public void TestFun4<T>(T a) where T : ITest
    {
        Debug.Log("有约束有参数，约束不是类");
    }





}



#endregion
#region 系统类型加特性

public static class Lesson10
{
    [CSharpCallLua]
    public static List<Type> csharpCallLuaList = new List<Type>()
    {
        typeof(UnityAction<float>)
        //自定义委托也可以加载列表中，都会被特性标注记录到xlua中
    };

    [LuaCallCSharp]
    public static List<Type> luaCallCSharpList = new List<Type>()
    {
        typeof (GameObject),
        typeof(Rigidbody)
    };
}


#endregion
#region 判空

[LuaCallCSharp]
public static class Lesson9
{
    //拓展一个Object判空的方法，给lua使用，lua 没有null
    public static bool IsNull(this UnityEngine.Object obj)
    {
        return obj == null;
    }
}

#endregion
#region 二维数组遍历

public class Lesson8
{
    public int[,] array = new int[2, 3] { {1,3,5 },{2,4,6 } };

}


#endregion
#region 7.委托

public class Lesson7
{
    public UnityAction del;

    public event UnityAction eventAction;

    public void DoEvent()
    {
        if (eventAction != null) eventAction();
    }
    public void Clear()
    {
        eventAction = null;
    }

}


#endregion
#region 6. 重载函数

public class Lesson6
{
    public int Calc()
    {
        return 100;
    }
    public int Calc(int a)
    {
        return a;
    }


    public int Calc(int a,int b)
    {
        return a + b;
    }

    public float Calc(float a)
    {
        return a;
    }
}


#endregion
#region 5. ref&out

public class Lesson5
{
    public int RefFun(int a,ref int b,ref int c,int d)
    {
        b = a + b;
        c = c+d;
        return 100;
    }
    public int OutFun(int a, out int b, out int c, int d)
    {
        b = a + d;
        c = a - d;
        return 200;
    }

    public int RefOutFun(int a, out int b, ref int c)
    {
        b = a *10;
        c = a *20;
        return 300;
    }
}



#endregion
#region 4. 拓展方法

//建议在lua中要使用的类都加该特性，提升性能
//lua通过反射调用C#类
//添加特性可以提前标注，不用反射
[LuaCallCSharp]
public static class Tools
{
    public static void Move(this Lesson4 obj)
    {
        Debug.Log(obj.name + "移动前: "+obj.step);
        obj.step += 1;
        Debug.Log(obj.name + "移动后：" +obj.step);
    }
}

public class Lesson4
{
    public string name = "吴彦祖";
    public int step = 0;
    public void Speak(string str)
    {
        Debug.Log(str);
    }

    public static void Eat()
    {
        Debug.Log("吃东西");
    }
}


#endregion
#region 3.数组

public class Lesson3
{
    public int[] array=new int[4] { 1, 2, 3, 4 };

    public List<int> list=new List<int>();

    public Dictionary<int,string> dic=new Dictionary<int,string>();

}




#endregion
#region 2.枚举
public enum E_MyEnum
{
    Idle,
    Move,
    Attack
}

#endregion
#region 1.类

public class Test
{
    public void Speak(string str)
    {
        Debug.Log("无命名空间："+str);
    }
}

namespace NewSpace
{
    public class Test
    {
        public void Speak(string str)
        {
            Debug.Log("有命名空间"+str);
        }
    }

}

#endregion