using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class ABMgr : MonoBehaviour
{
    private static ABMgr instance;
    public static ABMgr Instance { 
        get {
        if (instance == null)
            {
                GameObject obj = new GameObject();
                obj.name = "ABMgr";
                instance = obj.AddComponent<ABMgr>();
            }
        return instance;
        }
        
    }
    /// <summary>
    /// 主包
    /// </summary>
    private AssetBundle mainAB = null;
    /// <summary>
    /// 依赖包记录文件
    /// </summary>
    private AssetBundleManifest manifest = null;



    /// <summary>
    /// 存储加载过的ab包
    /// </summary>
    private Dictionary<string,AssetBundle> abDic = new Dictionary<string,AssetBundle>();

    private string PathUrl
    {
        get
        {
            return Application.streamingAssetsPath + "/";
        }
    }

    private string MainABName
    {
        get
        {
#if UNITY_IOS
return "IOS";
#elif UNITY_ANDROID
return "ANDROID";
#else 
            return "PC";
#endif
        }
    }
    #region 同步加载

    public object LoadRes(string abName,string resName)
    {
        LoadAB(abName);

        //如果资源是GameObject，实例化再返回
        Object obj = abDic[abName].LoadAsset(resName);
        if (obj is GameObject)
           return Instantiate(obj);
        else
             return obj;
    }


    public object LoadRes(string abName, string resName,System.Type type)
    {
        LoadAB(abName);

        //如果资源是GameObject，实例化再返回
        Object obj = abDic[abName].LoadAsset(resName,type);
        if (obj is GameObject)
            return Instantiate(obj);
        else
            return obj;
    }

    public T LoadRes<T>(string abName, string resName)where T : Object
    {
        LoadAB(abName);

        //如果资源是GameObject，实例化再返回
        T obj = abDic[abName].LoadAsset<T>(resName);
        if (obj is GameObject)
            return Instantiate(obj);
        else
            return obj;

    }

    /// <summary>
    /// 加载指定名称的ab包
    /// </summary>
    /// <param name="abName">包名</param>
    private void LoadAB(string abName)
    {
        //加载主包
        if (mainAB == null)
        {
            mainAB = AssetBundle.LoadFromFile(PathUrl + MainABName);
            manifest = mainAB.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        }

        //获取依赖包相关信息
        string[] strs = manifest.GetAllDependencies(abName);
        //确认依赖包是否被加载过
        for (int i = 0; i < strs.Length; i++)
        {
            if (!abDic.ContainsKey(strs[i]))
            {
                AssetBundle assetBundle = AssetBundle.LoadFromFile(PathUrl + strs[i]);
                abDic.Add(strs[i], assetBundle);
            }
        }

        //加载目标ab包
        if (!abDic.ContainsKey(abName))
        {
            AssetBundle targetAB = AssetBundle.LoadFromFile(PathUrl + abName);
            abDic.Add(abName, targetAB);
        }

    }
    #endregion

    #region  异步加载

    public void LoadResAsync(string abName, string resName, UnityAction<Object> callback)
    {
        StartCoroutine(ReallyLoadResAsync(abName,resName,callback));
    }


    private IEnumerator ReallyLoadResAsync(string abName, string resName, UnityAction<Object> callback)
    {
        LoadABAsync(abName);

        AssetBundleRequest abr = abDic[abName].LoadAssetAsync(resName);
        yield return abr;

        if (abr.asset is GameObject)
            callback(Instantiate(abr.asset));
        else
            callback(abr.asset);
    }

    public void LoadResAsync(string abName, string resName,System.Type type, UnityAction<Object> callback)
    {
        StartCoroutine(ReallyLoadResAsync(abName, resName,type, callback));
    }


    private IEnumerator ReallyLoadResAsync(string abName, string resName, System.Type type, UnityAction<Object> callback)
    {
        LoadABAsync(abName);

        AssetBundleRequest abr = abDic[abName].LoadAssetAsync(resName,type);
        yield return abr;

        if (abr.asset is GameObject)
            callback(Instantiate(abr.asset));
        else
            callback(abr.asset);
    }

    public void LoadResAsync<T>(string abName, string resName, UnityAction<T> callback)where T : Object
    {
        StartCoroutine(ReallyLoadResAsync<T>(abName, resName, callback));
    }


    private IEnumerator ReallyLoadResAsync<T>(string abName, string resName, UnityAction<T> callback) where T : Object
    {
        LoadABAsync(abName);

        AssetBundleRequest abr = abDic[abName].LoadAssetAsync<T>(resName);
        yield return abr;

        if (abr.asset is GameObject)
            callback(Instantiate(abr.asset as T));
        else
            callback(abr.asset as T);
    }

    private IEnumerator LoadABAsync(string abName)
    {
        //加载主包
        if (mainAB == null)
        {
            mainAB = AssetBundle.LoadFromFile(PathUrl + MainABName);
            AssetBundleRequest mainRequest = mainAB.LoadAssetAsync<AssetBundleManifest>("AssetBundleManifest");
            yield return mainRequest;
            manifest = mainRequest.asset as AssetBundleManifest;
        }

        //获取依赖包相关信息
        string[] strs = manifest.GetAllDependencies(abName);
        //确认依赖包是否被加载过
        for (int i = 0; i < strs.Length; i++)
        {
            if (!abDic.ContainsKey(strs[i]))
            {
                AssetBundleCreateRequest createRequest = AssetBundle.LoadFromFileAsync(PathUrl + strs[i]);
                yield return createRequest;
                abDic.Add(strs[i], createRequest.assetBundle);
            }
        }

        //加载目标ab包
        if (!abDic.ContainsKey(abName))
        {
            AssetBundleCreateRequest targetRequest = AssetBundle.LoadFromFileAsync(PathUrl + abName);
            yield return targetRequest;
            abDic.Add(abName, targetRequest.assetBundle);
        }
    }
    #endregion


    /// <summary>
    /// 卸载单个包
    /// </summary>
    /// <param name="abName"></param>
    public void UnLoad(string abName)
    {
        if(abDic.ContainsKey(abName))
        {
            abDic[abName].Unload(false);
            abDic.Remove(abName);
        }
    }
    /// <summary>
    /// 卸载所有ab包
    /// </summary>
    public void ClearAB()
    {
        AssetBundle.UnloadAllAssetBundles(false);
        abDic.Clear();
        mainAB= null;
        manifest = null;
    }


}
