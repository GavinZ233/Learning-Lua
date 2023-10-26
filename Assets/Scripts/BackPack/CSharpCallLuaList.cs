using System;
using System.Collections.Generic;
using UnityEngine.Events;
using XLua;

public static class CSharpCallLuaList
{
    [CSharpCallLua]
    public static List<Type> cSharpCallLuaList=new List<Type>()
    { 
        typeof(UnityAction<bool>)
    
    };
}
