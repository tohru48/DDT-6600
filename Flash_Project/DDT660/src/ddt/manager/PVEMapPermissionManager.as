package ddt.manager
{
   import flash.utils.Dictionary;
   
   public class PVEMapPermissionManager
   {
      
      private static var _instance:PVEMapPermissionManager;
      
      private var allPermission:Dictionary = new Dictionary();
      
      public function PVEMapPermissionManager()
      {
         super();
      }
      
      public static function get Instance() : PVEMapPermissionManager
      {
         if(_instance == null)
         {
            _instance = new PVEMapPermissionManager();
         }
         return _instance;
      }
      
      public function getPermisitonKey(mapid:int, level:int) : int
      {
         var key:Array = [String(mapid),String(level)];
         var keyString:String = key.join("|");
         return this.allPermission[keyString];
      }
      
      public function getPermission(mapid:int, level:int, mapPermission:String) : Boolean
      {
         var right:String = mapPermission.substr(mapid - 1,1).toUpperCase();
         if(right == "")
         {
            return false;
         }
         if(level == 0)
         {
            return true;
         }
         if(level == 1)
         {
            return right != "1" ? true : false;
         }
         if(level == 2)
         {
            if(right == "F" || right == "7")
            {
               return true;
            }
            return false;
         }
         if(level == 3)
         {
            return right == "F" ? true : false;
         }
         return false;
      }
      
      public function getPveMapEpicPermission(mapId:int, pveEpicPermission:String) : Boolean
      {
         var arr:Array = null;
         var str:String = null;
         var bool:Boolean = false;
         if(Boolean(pveEpicPermission))
         {
            arr = pveEpicPermission.split("-");
            for each(str in arr)
            {
               if(str == String(mapId))
               {
                  bool = true;
                  break;
               }
            }
         }
         return bool;
      }
   }
}

