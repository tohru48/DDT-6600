package ddt.manager
{
   import calendar.CalendarManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import ddt.data.BuffType;
   import ddt.data.FightBuffInfo;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   
   public class BuffManager
   {
      
      private static var _buffTemplateInfo:Dictionary = new Dictionary();
      
      private static var _templateInfoLoaded:Boolean = false;
      
      private static var _effectLoaded:Boolean = false;
      
      public function BuffManager()
      {
         super();
      }
      
      public static function creatBuff(buffid:int) : FightBuffInfo
      {
         var buff:FightBuffInfo = new FightBuffInfo(buffid);
         if(BuffType.isCardBuff(buff))
         {
            buff.type = BuffType.CARD_BUFF;
            translateDisplayID(buff);
         }
         else if(BuffType.isConsortiaBuff(buff))
         {
            buff.type = BuffType.CONSORTIA;
            translateDisplayID(buff);
         }
         else if(BuffType.isLocalBuffByID(buffid))
         {
            buff.type = BuffType.Local;
            translateDisplayID(buff);
            if(BuffType.isLuckyBuff(buffid) && CalendarManager.getInstance().luckyNum >= 0)
            {
               buff.displayid = CalendarManager.getInstance().luckyNum + 40;
            }
         }
         else
         {
            buff.displayid = buff.id;
         }
         return buff;
      }
      
      private static function translateDisplayID(buff:FightBuffInfo) : void
      {
         switch(buff.id)
         {
            case BuffType.AddPercentDamage:
               buff.displayid = BuffType.AddDamage;
               break;
            case BuffType.SetDefaultDander:
               buff.displayid = BuffType.TurnAddDander;
               break;
            case BuffType.AddDander:
               buff.displayid = BuffType.TurnAddDander;
               break;
            default:
               buff.displayid = buff.id;
         }
      }
      
      public static function startLoadBuffEffect() : void
      {
         var buff:BuffTemplateInfo = null;
         var args:URLVariables = null;
         var loader:BaseLoader = null;
         if(!_effectLoaded)
         {
            if(_templateInfoLoaded)
            {
               for each(buff in _buffTemplateInfo)
               {
                  if(Boolean(buff.EffectPic))
                  {
                     LoadResourceManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(buff.EffectPic),BaseLoader.MODULE_LOADER);
                  }
               }
               _effectLoaded = true;
            }
            else
            {
               args = new URLVariables();
               args["rnd"] = Math.random();
               loader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetSkillElementInfo.xml"),BaseLoader.TEXT_LOADER,args);
               loader.addEventListener(LoaderEvent.COMPLETE,onComplete);
               LoadResourceManager.Instance.startLoad(loader);
            }
         }
      }
      
      private static function onComplete(event:LoaderEvent) : void
      {
         var xml:XML = null;
         var xmlList:XMLList = null;
         var item:XML = null;
         var buff:BuffTemplateInfo = null;
         var loader:BaseLoader = event.loader;
         loader.removeEventListener(LoaderEvent.COMPLETE,onComplete);
         if(loader.isSuccess)
         {
            xml = new XML(loader.content);
            xmlList = xml..item;
            for each(item in xmlList)
            {
               buff = new BuffTemplateInfo();
               buff.ID = item.@ID;
               buff.Name = item.@Name;
               buff.Description = item.@Description;
               buff.EffectPic = item.@EffectPic;
               _buffTemplateInfo[buff.ID] = buff;
            }
            _templateInfoLoaded = true;
            startLoadBuffEffect();
         }
      }
      
      public static function getBuffById(id:int) : BuffTemplateInfo
      {
         return _buffTemplateInfo[id];
      }
   }
}

class BuffTemplateInfo
{
   
   public var ID:int;
   
   public var Name:String;
   
   public var Description:String;
   
   public var EffectPic:String;
   
   public function BuffTemplateInfo()
   {
      super();
   }
}
