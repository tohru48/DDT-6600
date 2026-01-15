package ddt.view.character
{
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   
   public class LayerFactory implements ILayerFactory
   {
      
      private static var _instance:ILayerFactory;
      
      public static const ICON:String = "icon";
      
      public static const SHOW:String = "show";
      
      public static const GAME:String = "game";
      
      public static const STATE:String = "state";
      
      public static const ROOM:String = "room";
      
      public static const SPECIAL_EFFECT:String = "specialEffect";
      
      public function LayerFactory()
      {
         super();
      }
      
      public static function get instance() : ILayerFactory
      {
         if(_instance == null)
         {
            _instance = new LayerFactory();
         }
         return _instance;
      }
      
      public function createLayer(info:ItemTemplateInfo, sex:Boolean, color:String = "", type:String = "show", gunBack:Boolean = false, hairType:int = 1, pic:String = null, stateType:String = "") : ILayer
      {
         var _layer:ILayer = null;
         switch(type)
         {
            case ICON:
               _layer = new IconLayer(info,color,gunBack,hairType);
               break;
            case SHOW:
               if(Boolean(info))
               {
                  if(info.CategoryID == EquipType.WING)
                  {
                     _layer = new BaseWingLayer(info);
                  }
                  else
                  {
                     _layer = new ShowLayer(info,color,gunBack,hairType,pic);
                  }
               }
               break;
            case GAME:
               if(Boolean(info))
               {
                  if(info.CategoryID == EquipType.WING)
                  {
                     _layer = new BaseWingLayer(info,BaseWingLayer.GAME_WING);
                  }
                  else
                  {
                     _layer = new GameLayer(info,color,gunBack,hairType,pic,stateType);
                  }
               }
               break;
            case STATE:
               _layer = new StateLayer(info,sex,color,int(stateType));
               break;
            case SPECIAL_EFFECT:
               _layer = new SpecialEffectsLayer(int(stateType));
               break;
            case ROOM:
               _layer = new RoomLayer(info,"",false,1,null,int(stateType));
         }
         return _layer;
      }
   }
}

