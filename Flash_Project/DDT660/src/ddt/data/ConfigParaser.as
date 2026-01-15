package ddt.data
{
   import baglocked.BagLockedController;
   import com.pickgliss.utils.StringUtils;
   import ddt.manager.LandersAwardManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StatisticManager;
   import flash.display.LoaderInfo;
   import flash.system.Security;
   import game.GameManager;
   
   public class ConfigParaser
   {
      
      public function ConfigParaser()
      {
         super();
      }
      
      public static function paras(config:XML, loaderInfo:LoaderInfo, username:String) : void
      {
         var f:XML = null;
         var notification:XMLList = null;
         var noti:XML = null;
         var grade:String = null;
         var site:String = null;
         var pathInfo:PathInfo = new PathInfo();
         pathInfo.SITEII = String(loaderInfo.parameters["site"]);
         if(pathInfo.SITEII == "undefined")
         {
            pathInfo.SITEII = "";
         }
         pathInfo.SITE = config.SITE.@value;
         pathInfo.WEEKLY_SITE = config.WEEKLYSITE.@value;
         pathInfo.BACKUP_FLASHSITE = config.BACKUP_FLASHSITE.@value;
         pathInfo.FLASHSITE = config.FLASHSITE.@value;
         pathInfo.COMMUNITY_FRIEND_PATH = config.COMMUNITY_FRIEND_PATH.@value;
         if(Boolean(config.COMMUNITY_MICROBLOG.hasOwnProperty("@value")))
         {
            pathInfo.COMMUNITY_MICROBLOG = StringUtils.converBoolean(config.COMMUNITY_MICROBLOG.@value);
         }
         if(Boolean(config.LIKEPERSON_SELECTED.hasOwnProperty("@value")))
         {
            pathInfo.LIKEPERSON_SELECTED = StringUtils.converBoolean(config.LIKEPERSON_SELECTED.@value);
         }
         if(Boolean(config.COMMUNITY_SINA_SECOND_MICROBLOG.hasOwnProperty("@value")))
         {
            pathInfo.COMMUNITY_SINA_SECOND_MICROBLOG = StringUtils.converBoolean(config.COMMUNITY_SINA_SECOND_MICROBLOG.@value);
         }
         if(Boolean(config.COMMUNITY_FRIEND_PATH.hasOwnProperty("@isUser")))
         {
            PathInfo.isUserAddFriend = StringUtils.converBoolean(config.COMMUNITY_FRIEND_PATH.@isUser);
         }
         pathInfo.USER_NAME = username;
         pathInfo.STYLE_PATH = config.STYLE_PATH.@value;
         pathInfo.FIRSTPAGE = config.FIRSTPAGE.@value;
         pathInfo.REGISTER = config.REGISTER.@value;
         pathInfo.REQUEST_PATH = config.REQUEST_PATH.@value;
         pathInfo.FILL_PATH = String(config.FILL_PATH.@value).replace("{user}",username);
         pathInfo.FILL_PATH = pathInfo.FILL_PATH.replace("{site}",pathInfo.SITEII);
         pathInfo.FILL_PATH_FBAPP = config.FILL_PATH_FBAPP.@value;
         pathInfo.LOGIN_PATH = String(config.LOGIN_PATH.@value).replace("{user}",username);
         pathInfo.LOGIN_PATH = pathInfo.LOGIN_PATH.replace("{site}",pathInfo.SITEII);
         pathInfo.OFFICIAL_SITE = config.OFFICIAL_SITE.@value;
         pathInfo.GAME_FORUM = config.GAME_FORUM.@value;
         pathInfo.DISABLE_TASK_ID = config.DISABLE_TASK_ID.@value;
         pathInfo.LITTLEGAMEMINLV = config.LITTLEGAMEMINLV.@value;
         if(Boolean(config.LOGIN_PATH.hasOwnProperty("@siteName")))
         {
            StatisticManager.siteName = config.LOGIN_PATH.@siteName;
         }
         pathInfo.TRAINER_STANDALONE = String(config.TRAINER_STANDALONE.@value) == "false" ? false : true;
         pathInfo.TRAINER_PATH = config.TRAINER_PATH.@value;
         pathInfo.COUNT_PATH = config.COUNT_PATH.@value;
         pathInfo.PARTER_ID = config.PARTER_ID.@value;
         pathInfo.CLIENT_DOWNLOAD = config.CLIENT_DOWNLOAD.@value;
         if(Boolean(config.STATISTIC.hasOwnProperty("@value")))
         {
         }
         var sucideTime:int = int(config.SUCIDE_TIME.@value);
         if(sucideTime > 0)
         {
            PathInfo.SUCIDE_TIME = sucideTime * 1000;
         }
         var boxStyle:int = int(config.BOX_STYLE.@value);
         if(boxStyle != 0)
         {
         }
         pathInfo.PHP_PATH = config.PHP.@site;
         if(Boolean(config.PHP.hasOwnProperty("@link")))
         {
            pathInfo.PHP_IMAGE_LINK = StringUtils.converBoolean(config.PHP.@link);
         }
         pathInfo.WEB_PLAYER_INFO_PATH = config.PHP.@infoPath;
         if(Boolean(config.PHP.hasOwnProperty("@isShow")))
         {
            PlayerManager.isShowPHP = StringUtils.converBoolean(config.PHP.@isShow);
         }
         if(Boolean(config.PHP.hasOwnProperty("@link")))
         {
            pathInfo.PHP_IMAGE_LINK = StringUtils.converBoolean(config.PHP.@link);
         }
         PathInfo.MUSIC_LIST = String(config.MUSIC_LIST.@value).split(",");
         PathInfo.LANGUAGE = String(config.LANGUAGE.@value);
         var list:XMLList = config.POLICY_FILES.file;
         for each(f in list)
         {
            Security.loadPolicyFile(f.@value);
         }
         if(Boolean(config.GAME_BOXPIC.hasOwnProperty("@value")))
         {
            PathInfo.GAME_BOXPIC = config.GAME_BOXPIC.@value;
         }
         if(Boolean(config.ISTOPDERIICT.hasOwnProperty("@value")))
         {
            PathInfo.ISTOPDERIICT = StringUtils.converBoolean(config.ISTOPDERIICT.@value);
         }
         pathInfo.COMMUNITY_INVITE_PATH = config.COMMUNITY_INVITE_PATH.@value;
         pathInfo.COMMUNITY_FRIEND_LIST_PATH = config.COMMUNITY_FRIEND_LIST_PATH.@value;
         pathInfo.SNS_PATH = config.COMMUNITY_FRIEND_LIST_PATH.@snsPath;
         pathInfo.MICROCOBOL_PATH = config.COMMUNITY_FRIEND_LIST_PATH.@microcobolPath;
         if(Boolean(config.COMMUNITY_FRIEND_LIST_PATH.hasOwnProperty("@isexist")))
         {
            pathInfo.COMMUNITY_EXIST = StringUtils.converBoolean(config.COMMUNITY_FRIEND_LIST_PATH.@isexist);
         }
         if(Boolean(config.COMMUNITY_FRIEND_INVITED_SWITCH.hasOwnProperty("@value")))
         {
            pathInfo.COMMUNITY_FRIEND_INVITED_SWITCH = StringUtils.converBoolean(config.COMMUNITY_FRIEND_INVITED_SWITCH.@value);
         }
         if(Boolean(config.COMMUNITY_FRIEND_INVITED_SWITCH.hasOwnProperty("@invitedOnline")))
         {
            pathInfo.COMMUNITY_FRIEND_INVITED_ONLINE_SWITCH = StringUtils.converBoolean(config.COMMUNITY_FRIEND_INVITED_SWITCH.@invitedOnline);
         }
         if(Boolean(config.COMMUNITY_FRIEND_LIST_PATH.hasOwnProperty("@isexistBtnVisble")))
         {
            pathInfo.IS_VISIBLE_EXISTBTN = StringUtils.converBoolean(config.COMMUNITY_FRIEND_LIST_PATH.@isexistBtnVisble);
         }
         pathInfo.ALLOW_POPUP_FAVORITE = String(config.ALLOW_POPUP_FAVORITE.@value) == "true" ? true : false;
         if(Boolean(config.FILL_JS_COMMAND.hasOwnProperty("@enable")))
         {
            pathInfo.FILL_JS_COMMAND_ENABLE = StringUtils.converBoolean(config.FILL_JS_COMMAND.@enable);
         }
         if(Boolean(config.FILL_JS_COMMAND.hasOwnProperty("@value")))
         {
            pathInfo.FILL_JS_COMMAND_VALUE = config.FILL_JS_COMMAND.@value;
         }
         if(Boolean(config.MINLEVELDUPLICATE.hasOwnProperty("@value")))
         {
            GameManager.MinLevelDuplicate = config.MINLEVELDUPLICATE.@value;
         }
         pathInfo.FIGHTLIB_ENABLE = StringUtils.converBoolean(config.FIGHTLIB.@value);
         if(Boolean(config.FEEDBACK))
         {
            if(Boolean(config.FEEDBACK.hasOwnProperty("@enable")))
            {
               pathInfo.FEEDBACK_ENABLE = String(config.FEEDBACK.@enable) == "true" ? true : false;
               pathInfo.FEEDBACK_TEL_NUMBER = config.FEEDBACK.@telNumber;
            }
         }
         if(config.MODULE != null && config.MODULE.SPA != null && Boolean(config.MODULE.SPA.hasOwnProperty("@enable")))
         {
            pathInfo.SPA_ENABLE = config.MODULE.SPA.@enable != "false";
         }
         if(config.MODULE != null && config.MODULE.CIVIL != null && Boolean(config.MODULE.CIVIL.hasOwnProperty("@enable")))
         {
            pathInfo.CIVIL_ENABLE = config.MODULE.CIVIL.@enable != "false";
         }
         if(config.MODULE != null && config.MODULE.CHURCH != null && Boolean(config.MODULE.CHURCH.hasOwnProperty("@enable")))
         {
            pathInfo.CHURCH_ENABLE = config.MODULE.CHURCH.@enable != "false";
         }
         if(config.MODULE != null && config.MODULE.WEEKLY != null && Boolean(config.MODULE.WEEKLY.hasOwnProperty("@enable")))
         {
            pathInfo.WEEKLY_ENABLE = config.MODULE.WEEKLY.@enable != "false";
         }
         if(Boolean(config.FORTH_ENABLE.hasOwnProperty("@value")))
         {
            pathInfo.FORTH_ENABLE = config.FORTH_ENABLE.@value != "false";
         }
         if(Boolean(config.QUEST_TRUSTEESHIP.hasOwnProperty("@enable")))
         {
            pathInfo.QUEST_TRUSTEESHIP_ENABLE = config.QUEST_TRUSTEESHIP.@enable != "false";
         }
         if(Boolean(config.TRUSTEESHIP.hasOwnProperty("@enable")))
         {
            pathInfo.Trusteeship_ENABLE = config.TRUSTEESHIP.@enable != "false";
         }
         if(Boolean(config.STHRENTH_MAX.hasOwnProperty("@value")))
         {
            pathInfo.STHRENTH_MAX = int(config.STHRENTH_MAX.@value);
         }
         if(Boolean(config.USER_GUILD_ENABLE.hasOwnProperty("@value")))
         {
            pathInfo.USER_GUILD_ENABLE = StringUtils.converBoolean(config.USER_GUILD_ENABLE.@value);
         }
         if(Boolean(config.ACHIEVE_ENABLE.hasOwnProperty("@value")))
         {
            pathInfo.ACHIEVE_ENABLE = config.ACHIEVE_ENABLE.@value != "false";
         }
         if(config.CHAT_FACE != null && config.CHAT_FACE.DISABLED_LIST != null && Boolean(config.CHAT_FACE.DISABLED_LIST.hasOwnProperty("@list")))
         {
            pathInfo.CHAT_FACE_DISABLED_LIST = String(config.CHAT_FACE.DISABLED_LIST.@list).split(",");
         }
         if(Boolean(config.STATISTICS.hasOwnProperty("@enable")))
         {
            pathInfo.STATISTICS = config.STATISTICS.@enable != "false";
         }
         if(Boolean(config.USER_GUIDE.hasOwnProperty("@value")) || true)
         {
         }
         if(config.GAME_FRAME_CONFIG != null && config.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG != null && Boolean(config.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG.hasOwnProperty("@value")))
         {
            pathInfo.FRAME_TIME_OVER_TAG = int(config.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG.@value);
         }
         if(config.GAME_FRAME_CONFIG != null && config.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG != null && Boolean(config.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG.hasOwnProperty("@value")))
         {
            pathInfo.FRAME_OVER_COUNT_TAG = int(config.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG.@value);
         }
         if(config.EXTERNAL_INTERFACE_360 != null && Boolean(config.EXTERNAL_INTERFACE_360.hasOwnProperty("@value")))
         {
            pathInfo.EXTERNAL_INTERFACE_PATH_360 = String(config.EXTERNAL_INTERFACE_360.@value);
         }
         if(config.EXTERNAL_INTERFACE_360 != null && Boolean(config.EXTERNAL_INTERFACE_360.hasOwnProperty("@enable")))
         {
            pathInfo.EXTERNAL_INTERFACE_ENABLE_360 = config.EXTERNAL_INTERFACE_360.@enable != "false";
         }
         if(config.GRADE_NOTIFICATION != null && config.GRADE_NOTIFICATION.NOTIFICATION != null)
         {
            notification = config.GRADE_NOTIFICATION.NOTIFICATION;
            for each(noti in notification)
            {
               if(!(!noti.hasOwnProperty("@grade") || !noti.hasOwnProperty("@site")))
               {
                  grade = noti.@grade;
                  site = noti.@site;
                  if(!(grade == "" || site == ""))
                  {
                     pathInfo.GRADE_NOTIFICATION[grade] = site;
                  }
               }
            }
         }
         if(config.CALL_PATH != null && Boolean(config.CALL_PATH.hasOwnProperty("@value")))
         {
            pathInfo.CALL_LOGIN_INTERFAECE = config.CALL_PATH.@value;
         }
         if(config.USER_ACTION_NOTICE != null && Boolean(config.USER_ACTION_NOTICE.hasOwnProperty("@value")))
         {
            pathInfo.USER_ACTION_NOTICE = config.USER_ACTION_NOTICE.@value;
         }
         if(Boolean(config.RANDOM_CHANNEL) && Boolean(config.RANDOM_CHANNEL.hasOwnProperty("@value")))
         {
            pathInfo.RANDOM_CHANNEL = config.RANDOM_CHANNEL.@value != "false";
         }
         if(Boolean(config.CROSSBUGGLE.hasOwnProperty("@enable")))
         {
            pathInfo.CROSSBUGGLE = config.CROSSBUGGLE.@enable != "false";
         }
         if(Boolean(config.LOTTERY.hasOwnProperty("@enable")))
         {
            pathInfo.LOTTERY_ENABLE = config.LOTTERY.@enable != "false";
         }
         if(Boolean(config.OVERSEAS))
         {
            pathInfo.OVERSEAS_COMMUNITY_TYPE = int(config.OVERSEAS.OVERSEAS_COMMUNITY_TYPE.@value);
            pathInfo.OVERSEAS_COMMUNITY_PATH = config.OVERSEAS.OVERSEAS_COMMUNITY_TYPE.@callPath;
            pathInfo.OVERSEAS_COMMUNITY_CALLJS = config.OVERSEAS.OVERSEAS_COMMUNITY_TYPE.@callJS;
            pathInfo.COMMUNITY_EXIST = Boolean(pathInfo.OVERSEAS_COMMUNITY_TYPE);
            pathInfo.IS_VISIBLE_SHAREBTN = StringUtils.converBoolean(config.OVERSEAS.OVERSEAS_COMMUNITY_TYPE.@shareBtnVisble);
         }
         if(Boolean(config.HOTSPRING_CONTINUE.hasOwnProperty("@value")))
         {
            pathInfo.HOTSPRING_CONTINUE = config.HOTSPRING_CONTINUE.@value != "false";
         }
         if(StringUtils.trim(config.DUNGEON_OPENLIST.@value) != "")
         {
            pathInfo.DUNGEON_OPENLIST = StringUtils.trim(config.DUNGEON_OPENLIST.@value).split(",");
         }
         if(Boolean(config.SUIT.hasOwnProperty("@enable")))
         {
            pathInfo.SUIT_ENABLE = config.SUIT.@enable != "false";
         }
         if(StringUtils.trim(config.DUNGEON_OPENLIST.@advancedEnable) != "")
         {
            pathInfo.ADVANCED_ENABLE = config.DUNGEON_OPENLIST.@advancedEnable != "false";
         }
         if(StringUtils.trim(config.DUNGEON_OPENLIST.@footballEnable) != "")
         {
            pathInfo.FOOTBALL_ENABLE = config.DUNGEON_OPENLIST.@footballEnable != "false";
         }
         if(StringUtils.trim(config.DUNGEON_OPENLIST.@epicLevelEnable) != "")
         {
            pathInfo.EPICLEVEL_ENABLE = config.DUNGEON_OPENLIST.@epicLevelEnable != "false";
         }
         if(config.LOCK_SETTING != null && Boolean(config.LOCK_SETTING.hasOwnProperty("@value")))
         {
            BagLockedController.LOCK_SETTING = config.LOCK_SETTING.@value;
         }
         if(config.GAME_CAN_NOT_EXIT_SEND_LOG != null && Boolean(config.GAME_CAN_NOT_EXIT_SEND_LOG.hasOwnProperty("@value")))
         {
            GameManager.GAME_CAN_NOT_EXIT_SEND_LOG = config.GAME_CAN_NOT_EXIT_SEND_LOG.@value;
         }
         if(Boolean(config.EXALTBTN.hasOwnProperty("@enable")))
         {
            pathInfo.EXALT_ENABLE = config.EXALTBTN.@enable != "false";
         }
         if(Boolean(config.PK_BTN.hasOwnProperty("@enable")))
         {
            pathInfo.PK_BTN = config.PK_BTN.@enable == "true";
         }
         if(Boolean(config.SUIT.hasOwnProperty("@enable")))
         {
            pathInfo.SUIT_ENABLE = config.SUIT.@enable != "false";
         }
         if(Boolean(config.KINGBLESS.hasOwnProperty("@enable")))
         {
            pathInfo.KINGBLESS_ENABLE = config.KINGBLESS.@enable != "false";
         }
         if(Boolean(config.WARRIORS_FAM.hasOwnProperty("@enable")))
         {
            pathInfo.WARRIORS_FAM_ENABLE = config.WARRIORS_FAM.@enable != "false";
         }
         if(Boolean(config.GEMSTONE.hasOwnProperty("@enable")))
         {
            pathInfo.GEMSTONE_ENABLE = config.GEMSTONE.@enable != "false";
         }
         if(Boolean(config.ONEKEYDONE.hasOwnProperty("@enable")))
         {
            pathInfo.ONEKEY_DONE = config.ONEKEYDONE.@enable != "false";
         }
         if(Boolean(config.CROSS_CHAT_SERVER.hasOwnProperty("@enable")))
         {
            pathInfo.CROSS_CHAT_SERVER = config.CROSS_CHAT_SERVER.@enable != "false";
         }
         if(Boolean(config.TREASURE.hasOwnProperty("@enable")))
         {
            pathInfo.TREASURE = config.TREASURE.@enable != "false";
            pathInfo.TREASUREHELPTIMES = int(config.TREASURE.@times);
         }
         else
         {
            pathInfo.TREASURE = true;
            pathInfo.TREASUREHELPTIMES = 5;
         }
         if(Boolean(config.CROSS_CHAT_SERVER.hasOwnProperty("@enable")))
         {
            pathInfo.CROSS_CHAT_SERVER = config.CROSS_CHAT_SERVER.@enable != "false";
         }
         if(Boolean(config.CHECKDESK_KILL.hasOwnProperty("@enable")))
         {
            pathInfo.CHECKDESK_KILL = config.CHECKDESK_KILL.@enable != "false";
         }
         if(Boolean(config.HIT_SHELL.hasOwnProperty("@pointEnable")))
         {
            pathInfo.POINT_ENABLE = config.HIT_SHELL.@pointEnable != "false";
         }
         if(Boolean(config.HIT_SHELL.hasOwnProperty("@progressEnable")))
         {
            pathInfo.PROGRESS_ENABLE = config.HIT_SHELL.@progressEnable != "false";
         }
         if(Boolean(config.HIT_SHELL.hasOwnProperty("@dotteLineEnable")))
         {
            pathInfo.DOTTELINE_ENABLE = config.HIT_SHELL.@dotteLineEnable != "false";
         }
         if(Boolean(config.SMALLMAP.hasOwnProperty("@enable")))
         {
            pathInfo.SMALLMAP_ENABLE = config.SMALLMAP.@enable != "false";
         }
         if(Boolean(config.SMALLMAP.hasOwnProperty("@meterEnable")))
         {
            pathInfo.SMALLMAP_METERENABLE = config.SMALLMAP.@meterEnable != "false";
         }
         if(Boolean(config.SMALLMAP.hasOwnProperty("@borderEnable")))
         {
            pathInfo.SMALLMAP_BORDERENABLE = config.SMALLMAP.@borderEnable != "false";
         }
         if(Boolean(config.SMALLMAP.hasOwnProperty("@alphaEnable")))
         {
            pathInfo.SMALLMAP_BORDERALPHA = config.SMALLMAP.@alphaEnable != "false";
         }
         if(Boolean(config.DAILY.hasOwnProperty("@enable")))
         {
            pathInfo.DAILY_ENABLE = config.DAILY.@enable != "false";
         }
         if(config.CALLBACK_INTERFACE != null && Boolean(config.CALLBACK_INTERFACE.hasOwnProperty("@path")))
         {
            pathInfo.CALLBACK_INTERFACE_PATH = config.CALLBACK_INTERFACE.@path;
         }
         if(config.CALLBACK_INTERFACE != null && Boolean(config.CALLBACK_INTERFACE.hasOwnProperty("@enable")))
         {
            pathInfo.CALLBACK_INTERFACE_ENABLE = config.CALLBACK_INTERFACE.@enable;
         }
         if(Boolean(config.GODSYAH.hasOwnProperty("@enable")))
         {
            pathInfo.GODSYAH_ENABLE = config.GODSYAH.@enable == "true";
         }
         if(config.IS_SEND_RECORDUSERVERSION != null && Boolean(config.IS_SEND_RECORDUSERVERSION.hasOwnProperty("@value")))
         {
            pathInfo.IS_SEND_RECORDUSERVERSION = config.IS_SEND_RECORDUSERVERSION.@value == "true";
         }
         if(config.IS_SEND_FLASHINFO != null && Boolean(config.IS_SEND_FLASHINFO.hasOwnProperty("@value")))
         {
            pathInfo.IS_SEND_FLASHINFO = config.IS_SEND_FLASHINFO.@value == "true";
         }
         if(config.FLASH_P2P != null)
         {
            if(Boolean(config.FLASH_P2P.hasOwnProperty("@ebable")))
            {
               pathInfo.FLASH_P2P_EBABLE = config.FLASH_P2P.@ebable == "true";
            }
            if(Boolean(config.FLASH_P2P.hasOwnProperty("@key")))
            {
               pathInfo.FLASH_P2P_KEY = config.FLASH_P2P.@key;
            }
            if(Boolean(config.FLASH_P2P.hasOwnProperty("@url")))
            {
               pathInfo.FLASH_P2P_CIRRUS_URL = config.FLASH_P2P.@url;
            }
         }
         if(config.LANDERS_AWARD_4399 != null && Boolean(config.LANDERS_AWARD_4399.hasOwnProperty("@value")))
         {
            if(Boolean(config.SMALLMAP.hasOwnProperty("@borderEnable")))
            {
               pathInfo.SMALLMAP_BORDERENABLE = config.SMALLMAP.@borderEnable != "false";
            }
         }
         if(config.MAGICSTONE_DISCOUNT != null && Boolean(config.MAGICSTONE_DISCOUNT.hasOwnProperty("@enable")))
         {
            pathInfo.MAGICSTONE_DISCOUNT = config.MAGICSTONE_DISCOUNT.@enable == "true";
         }
         if(config.ADD_PUBLIC_TIP != null && Boolean(config.ADD_PUBLIC_TIP.hasOwnProperty("@value")))
         {
            pathInfo.ADD_PUBLIC_TIP = config.ADD_PUBLIC_TIP.@value == "true";
         }
         if(config.GAME_STATS != null && Boolean(config.GAME_STATS.hasOwnProperty("@enable")))
         {
            LandersAwardManager.LANDERS_AWARD_4399 = config.LANDERS_AWARD_4399.@value == "true";
            pathInfo.GAME_STATS_ENABLE = config.GAME_STATS.@enable == "true";
         }
         if(StringUtils.trim(config.DUNGEON_OPENLIST.@footballEnable) != "")
         {
            pathInfo.FOOTBALL_ENABLE = config.DUNGEON_OPENLIST.@footballEnable != "false";
         }
         if(config.MAGICSTONE_DISCOUNT != null && Boolean(config.MAGICSTONE_DISCOUNT.hasOwnProperty("@enable")))
         {
            pathInfo.MAGICSTONE_DISCOUNT = config.MAGICSTONE_DISCOUNT.@enable == "true";
         }
         if(config.FIGHT_TIME != null && Boolean(config.FIGHT_TIME.hasOwnProperty("@count")))
         {
            pathInfo.FIGHT_TIME = config.FIGHT_TIME.@count;
         }
         if(config.PETS_EAT != null && Boolean(config.PETS_EAT.hasOwnProperty("@enable")))
         {
            pathInfo.PETS_EAT = config.PETS_EAT.@enable == "true";
         }
         if(config.KINGFIGNT != null && Boolean(config.KINGFIGNT.hasOwnProperty("@enable")))
         {
            pathInfo.KINGFIGNT = config.KINGFIGNT.@enable == "true";
         }
         PathManager.setup(pathInfo);
      }
   }
}

