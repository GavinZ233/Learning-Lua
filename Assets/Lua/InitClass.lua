--面向对象的模拟
require("Object")
--字符串拆分
require("SplitTools")
--Json解析
Json=require("JsonUtility")

--Unity相关类
GameObject=CS.UnityEngine.GameObject
Resources=CS.UnityEngine.GameObject
Transform=CS.UnityEngine.Transform
RectTransform=CS.UnityEngine.RectTransform
Vector3=CS.UnityEngine.Vector3
Vector2=CS.UnityEngine.Vector2

SpriteAtlas=CS.UnityEngine.SpriteAtlas
TextAsset=CS.UnityEngine.TextAsset

--UI相关
UI=CS.UnityEngine.UI
Image=UI.Image
Text=UI.Text
Button=UI.Button
Toggle=UI.Toggle
ScrollRect=UI.ScrollRect


--自己的C#脚本      
ABMgr=CS.ABMgr.Instance

--仅适用当前demo,Canvas记录场景中Canvas的transform
Canvas=GameObject.Find("Canvas").transform





