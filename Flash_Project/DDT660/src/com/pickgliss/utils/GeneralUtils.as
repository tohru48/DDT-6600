package com.pickgliss.utils
{
   import org.as3commons.reflect.Accessor;
   import org.as3commons.reflect.Field;
   import org.as3commons.reflect.Type;
   import org.as3commons.reflect.Variable;
   
   public class GeneralUtils
   {
      
      public function GeneralUtils()
      {
         super();
      }
      
      public static function cloneObject(param1:*) : *
      {
         return doSerializeObject(param1,true);
      }
      
      public static function serializeObject(param1:*) : Object
      {
         return doSerializeObject(param1,false);
      }
      
      public static function deserializeObject(param1:Object) : *
      {
         return doDeserializeObject(param1);
      }
      
      private static function doDeserializeObject(param1:Object) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         var _loc8_:Field = null;
         var _loc2_:Type = Type.forName(param1["classFullName"]);
         var _loc3_:* = param1["warpObject"];
         var _loc4_:* = new _loc2_.clazz();
         if(_loc4_ is Vector.<*> || _loc4_ is Array)
         {
            for each(_loc5_ in _loc3_)
            {
               if(_loc5_ is String || _loc5_ is int || _loc5_ is uint || _loc5_ is Number || _loc5_ is Boolean)
               {
                  _loc4_.push(_loc5_);
               }
               else
               {
                  _loc4_.push(doDeserializeObject(_loc5_));
               }
            }
         }
         else
         {
            _loc6_ = null;
            if(param1["classFullName"] == "Object")
            {
               for(_loc7_ in _loc3_)
               {
                  _loc6_ = doDeserializeProperty(_loc3_[_loc7_],null);
                  _loc4_[_loc7_] = _loc6_;
               }
            }
            else
            {
               for each(_loc8_ in _loc2_.properties)
               {
                  if(_loc8_ is Variable || _loc8_ is Accessor && Accessor(_loc8_).writeable && _loc8_.name != "prototype")
                  {
                     _loc6_ = doDeserializeProperty(_loc3_[_loc8_.name],_loc8_);
                     _loc4_[_loc8_.name] = _loc6_;
                  }
               }
            }
         }
         return _loc4_;
      }
      
      private static function doDeserializeProperty(param1:*, param2:Field) : *
      {
         if(param1 != null)
         {
            if(param1 is Boolean || param1 is String || param1 is int || param1 is uint || param1 is Number)
            {
               return param1;
            }
            return doDeserializeObject(param1);
         }
         return null;
      }
      
      private static function doSerializeObject(param1:*, param2:Boolean, param3:Type = null) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         var _loc8_:Field = null;
         var _loc9_:Object = null;
         if(param3 == null)
         {
            param3 = Type.forInstance(param1);
         }
         if(param1 != null)
         {
            if(param1 is Vector.<*> || param1 is Array)
            {
               if(param2)
               {
                  _loc4_ = new param3.clazz();
               }
               else
               {
                  _loc4_ = [];
               }
               for each(_loc5_ in param1)
               {
                  if(_loc5_ is String || _loc5_ is int || _loc5_ is uint || _loc5_ is Number || _loc5_ is Boolean)
                  {
                     _loc4_.push(_loc5_);
                  }
                  else
                  {
                     _loc4_.push(doSerializeObject(_loc5_,param2));
                  }
               }
            }
            else
            {
               if(param2)
               {
                  _loc4_ = new param3.clazz();
               }
               else
               {
                  _loc4_ = {};
               }
               _loc6_ = null;
               if(param3.isDynamic)
               {
                  for(_loc7_ in param1)
                  {
                     if(param1[_loc7_] != null)
                     {
                        _loc6_ = doSerializeProperty(param1[_loc7_],param2,null);
                        _loc4_[_loc7_] = _loc6_;
                     }
                  }
               }
               else
               {
                  for each(_loc8_ in param3.properties)
                  {
                     if(_loc8_ is Variable || _loc8_ is Accessor && Accessor(_loc8_).writeable && _loc8_.name != "prototype")
                     {
                        if(param1[_loc8_.name] != null)
                        {
                           _loc6_ = doSerializeProperty(param1[_loc8_.name],param2,_loc8_);
                           _loc4_[_loc8_.name] = _loc6_;
                        }
                     }
                  }
               }
            }
            if(!param2)
            {
               _loc9_ = {};
               _loc9_["isCETransportObject"] = true;
               _loc9_["classFullName"] = param3.fullName;
               _loc9_["warpObject"] = _loc4_;
               return _loc9_;
            }
            return _loc4_;
         }
         return null;
      }
      
      private static function doSerializeProperty(param1:*, param2:Boolean, param3:Field) : *
      {
         if(Boolean(param3))
         {
            if(param3 is Variable || param3 is Accessor && Accessor(param3).writeable && param3.name != "prototype")
            {
               if(param3.type.fullName == "Boolean" || param3.type.fullName == "String" || param3.type.fullName == "int" || param3.type.fullName == "uint" || param3.type.fullName == "Number")
               {
                  return param1;
               }
               return doSerializeObject(param1,param2,param3.type);
            }
            return;
         }
         if(param1 is Boolean || param1 is String || param1 is int || param1 is uint || param1 is Number)
         {
            return param1;
         }
         return doSerializeObject(param1,param2,null);
      }
   }
}

