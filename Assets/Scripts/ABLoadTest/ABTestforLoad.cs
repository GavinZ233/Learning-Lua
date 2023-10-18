using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ABTestforLoad : MonoBehaviour
{
    public Image img;
    // Start is called before the first frame update
    void Start()
    {
        //TestFirst();

         GameObject obj =ABMgr.Instance.LoadRes<GameObject>("model","Cube");
        obj.transform.position = Vector3.one*3;

        ABMgr.Instance.LoadResAsync<GameObject>("model", "Cube", (o) =>
        {
            o.gameObject.SetActive(true);
        });
    }


    private void TestFirst()
    {
        //加载AB包,ab包不能重复加载

        AssetBundle bundle = AssetBundle.LoadFromFile(Application.streamingAssetsPath + "/" + "model");
        //加载ab包中的资源
        GameObject cube = bundle.LoadAsset("Cube", typeof(GameObject)) as GameObject;
        //实例化
        Instantiate(cube);


        //泛型加载
        GameObject cap = bundle.LoadAsset<GameObject>("Capsule");

        cap.GetComponent<Transform>().position += Vector3.up;
        Instantiate(cap, Vector3.one, Quaternion.identity);

        //单个ab包卸载
        //bundle.Unload(true);

        //异步加载
        StartCoroutine(LoadABRes("image", "Joe"));


        //加载主包
        AssetBundle abMain = AssetBundle.LoadFromFile(Application.streamingAssetsPath + "/" + "StandaloneWindows");
        //从主包加载依赖信息文件
        AssetBundleManifest abManifest = abMain.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        //从依赖文件中获取model的依赖包信息
        string[] strs = abManifest.GetAllDependencies("model");
        foreach (string str in strs)
        {
            print("model依赖包：" + str);
        }

    }

    IEnumerator LoadABRes(string abName, string resName)
    {
        AssetBundleCreateRequest abcr = AssetBundle.LoadFromFileAsync(Application.streamingAssetsPath + "/" + abName);
        yield return abcr;
        AssetBundleRequest abq = abcr.assetBundle.LoadAssetAsync(resName, typeof(Sprite));
        yield return abq;

        img.sprite = abq.asset as Sprite;
        img.rectTransform.localScale = Vector3.one * 5;


    }


    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            print("T");
            AssetBundle.UnloadAllAssetBundles(true);

        }
        if (Input.GetKeyDown(KeyCode.F))
        {
            print("F");

            //卸载AB包并不卸载资源
            AssetBundle.UnloadAllAssetBundles(false);

        }
    }
}
