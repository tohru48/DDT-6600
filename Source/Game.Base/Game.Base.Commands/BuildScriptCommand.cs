// Decompiled with JetBrains decompiler
// Type: Game.Base.Commands.BuildScriptCommand
// Assembly: Game.Base, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: B949F431-F080-4D69-92A0-7A4168242D9F
// Assembly location: C:\Users\Jhone\Desktop\Emuladores\Center\Game.Base.dll

using Game.Base;
using Game.Server.Managers;

namespace Game.Base.Commands
{
    [Cmd("&cs", ePrivLevel.Player, "Compile the C# scripts.", new string[] { "/cs  <source file> <target> <importlib>", "eg: /cs ./scripts temp.dll game.base.dll,game.logic.dll" })]
    public class BuildScriptCommand : AbstractCommandHandler, ICommandHandler
    {
        public bool OnCommand(BaseClient client, string[] args)
        {
            if (args.Length >= 4)
                ScriptMgr.CompileScripts(0 != 0, args[1], args[2], args[3].Split(','));
            else
                this.DisplaySyntax(client);
            return true;
        }
    }
}
