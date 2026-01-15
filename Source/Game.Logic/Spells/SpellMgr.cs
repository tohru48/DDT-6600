using Game.Base.Events;
using Game.Logic;
using Game.Logic.Phy.Object;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Logic.Spells
{
    public class SpellMgr
    {
        private static readonly ILog log;
        private static Dictionary<int, ISpellHandler> handles;

        static SpellMgr()
        {
            SpellMgr.log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            SpellMgr.handles = new Dictionary<int, ISpellHandler>();
        }

        public SpellMgr()
        {

        }

        public static ISpellHandler LoadSpellHandler(int code)
        {
            return SpellMgr.handles[code];
        }

        [ScriptLoadedEvent]
        public static void OnScriptCompiled(RoadEvent ev, object sender, EventArgs args)
        {
            SpellMgr.handles.Clear();
            int num = SpellMgr.SearchSpellHandlers(Assembly.GetAssembly(typeof(BaseGame)));
            if (!SpellMgr.log.IsInfoEnabled)
                return;
            SpellMgr.log.Info((object)("SpellMgr: Loaded " + (object)num + " spell handlers from GameServer Assembly!"));
        }

        protected static int SearchSpellHandlers(Assembly assembly)
        {
            int num = 0;
            foreach (Type type in assembly.GetTypes())
            {
                if (type.IsClass && type.GetInterface("Game.Logic.Spells.ISpellHandler") != null)
                {
                    SpellAttibute[] spellAttibuteArray = (SpellAttibute[])type.GetCustomAttributes(typeof(SpellAttibute), true);
                    if (spellAttibuteArray.Length > 0)
                    {
                        ++num;
                        SpellMgr.RegisterSpellHandler(spellAttibuteArray[0].Type, Activator.CreateInstance(type) as ISpellHandler);
                    }
                }
            }
            return num;
        }

        protected static void RegisterSpellHandler(int type, ISpellHandler handle)
        {
            SpellMgr.handles.Add(type, handle);
        }

        public static void ExecuteSpell(BaseGame game, Player player, ItemTemplateInfo item)
        {
            try
            {
                SpellMgr.LoadSpellHandler(item.Property1).Execute(game, player, item);
            }
            catch (Exception ex)
            {
                SpellMgr.log.Error((object)"Execute Spell Error:", ex);
            }
        }
    }
}
