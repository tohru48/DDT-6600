package ddt.utils
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import ddt.data.player.BasePlayer;
   import ddt.manager.LanguageMgr;
   import flash.geom.Point;
   
   public class PositionUtils
   {
      
      public function PositionUtils()
      {
         super();
      }
      
      public static function setPos(obj:*, posObject:*) : *
      {
         var pos:Point = null;
         if(posObject is String)
         {
            pos = ComponentFactory.Instance.creatCustomObject(posObject);
            obj.x = pos.x;
            obj.y = pos.y;
         }
         else if(posObject is Object)
         {
            obj.x = posObject.x;
            obj.y = posObject.y;
         }
         return obj;
      }
      
      public static function creatPoint(pointStyle:String) : Point
      {
         return ComponentFactory.Instance.creatCustomObject(pointStyle);
      }
      
      public static function adaptNameStyle(player:BasePlayer, nameTxt:FilterFrameText, vipTxt:GradientText) : void
      {
         if(Boolean(player))
         {
            if(player.isOld)
            {
               nameTxt.filterString = "core.playerNameTxt.GF";
               Helpers.setTextfieldFormat(nameTxt,{
                  "color":11400447,
                  "bold":false,
                  "font":LanguageMgr.GetTranslation("songti")
               },true);
               nameTxt.visible = true;
               if(Boolean(vipTxt))
               {
                  vipTxt.visible = false;
               }
            }
            else if(player.IsVIP)
            {
               if(Boolean(vipTxt))
               {
                  vipTxt.visible = true;
               }
               nameTxt.visible = false;
            }
            else
            {
               nameTxt.filterString = "core.playerNameTxt.GF2";
               Helpers.setTextfieldFormat(nameTxt,{
                  "color":0,
                  "bold":false,
                  "font":LanguageMgr.GetTranslation("songti")
               },true);
               nameTxt.visible = true;
               if(Boolean(vipTxt))
               {
                  vipTxt.visible = false;
               }
            }
         }
      }
   }
}

