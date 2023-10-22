using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LuaCallCSharp : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

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