using System.IO;
using UnityEngine;
using XLua;

/// <summary>
/// Lua管理器，提供lua解析器
/// </summary>
public class LuaMgr : BaseManager<LuaMgr>
{
    //执行Lua语言的函数
    //释放垃圾
    //销毁
    //重定向lua脚本读取

    /// <summary>
    /// 得到lua中的_G
    /// </summary>
    public LuaTable Global
    {
        get 
        {
            return luaEnv.Global;
        }
    }


    private LuaEnv luaEnv;
    
    public void Init()
    {
        if (luaEnv != null) return;
        //初始化解析器
        luaEnv = new LuaEnv();
        //Lua脚本重定向
        luaEnv.AddLoader(CustomLoader);
        luaEnv.AddLoader(CustomABLoader);

    }

    public void DoLuaFile(string fileName)
    {
        string str = string.Format("require('{0}')", fileName);
        DoString(str);
    }

    public void DoString(string str)
    {
        if (luaEnv == null)
            Debug.LogWarning("解析器未初始化");
        luaEnv.DoString(str);
    }

    public void Tick()
    {
        if (luaEnv == null)
            Debug.LogWarning("解析器未初始化");

        luaEnv.Tick();
    }

    public void Dispose()
    {
        if (luaEnv == null)
            Debug.LogWarning("解析器未初始化");

        luaEnv.Dispose();
        luaEnv = null;
    }

    private byte[] CustomLoader(ref string filePath)
    {
        string path = Application.dataPath + "/Lua/" + filePath + ".lua";
        Debug.Log(path);

        if (File.Exists(path))
        {
            return File.ReadAllBytes(path);
        }
        else
        {
            Debug.Log("LuaMgr.CustomLoader重定向路径失败，文件名：" + filePath);
        };
        return null;
    }

    //AB包中加载文本有限制，还是需要修改后缀为txt


    private byte[] CustomABLoader(ref string filePath)
    {
        //从AB包中加载Lua文件返回

        //string path = Application.streamingAssetsPath + "/lua";

        //AssetBundle ab=AssetBundle.LoadFromFile(path);

        //TextAsset tx=ab.LoadAsset<TextAsset>(filePath+".lua");

        //return tx.bytes;

        TextAsset ta =ABMgr.Instance.LoadRes<TextAsset>("lua", filePath + ".lua");

        if (ta != null)
            return ta.bytes;
        else
            Debug.LogWarning("LuaMgr.CustomABLoader重定向路径失败，文件名：" + filePath);

        return null;
    }

}
