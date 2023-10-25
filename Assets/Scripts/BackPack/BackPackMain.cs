using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackPackMain : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        LuaMgr.GetInstance().Init();
        LuaMgr.GetInstance().DoLuaFile("BackPackMain");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
