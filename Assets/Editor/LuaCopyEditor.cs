using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
public class LuaCopyEditor:Editor  
{
    [MenuItem("XLua/lua文件加txt")]
    public static void CopyLuaToTxt(){
        //找到所有Lua文件
        string path=Application.dataPath+"/Lua/";
        if(!Directory.Exists(path)) 
            return;

        //得到每一个lua文件的路径才能迁移拷贝
        string[] strs=Directory.GetFiles(path,"*.lua");

        //文件拷贝到新文件夹
        string newPath=Application.dataPath+"/LuaTxt/";

        //判断新路径文件夹是否存在
        if(!Directory.Exists(newPath))
            Directory.CreateDirectory(newPath);
        else
        {
            //得到该路径所有txt文件，删除
            string[] oldFileStrs=Directory.GetFiles(newPath,"*.txt");
            for (int i = 0; i < oldFileStrs.Length; i++)
            {
                File.Delete(oldFileStrs[i]);
            }
        }
        string fileName;//要保存的新路径名
        List<string> newFileNames=new List<string>();
        for (int i = 0; i < strs.Length; i++)
        {
            fileName=newPath+strs[i].Substring(strs[i].LastIndexOf("/")+1)+".txt";
            File.Copy(strs[i],fileName);
            newFileNames.Add(fileName);
        }
        AssetDatabase.Refresh();
        //如果不刷新，无法修改刚生成的资源

        for (int i = 0; i < newFileNames.Count; i++)
        {
            //传入路径是相对Assets的 
            string importerPath=newFileNames[i].Substring(newFileNames[i].IndexOf("Assets"));
            Debug.Log("AssetImporter"+importerPath);
            AssetImporter importer=AssetImporter.GetAtPath(importerPath);
           if(importer!=null)
              importer.assetBundleName="lua";
        }


    }
}