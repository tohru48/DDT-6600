// Decompiled with JetBrains decompiler
// Type: Game.Base.Commands.CommandMgrSetupCommand
// Assembly: Game.Base, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: B949F431-F080-4D69-92A0-7A4168242D9F
// Assembly location: C:\Users\Jhone\Desktop\Emuladores\Center\Game.Base.dll

using Game.Base;

namespace Game.Base.Commands
{
    [Cmd("&cmd", ePrivLevel.Admin, "Config the command system.", new string[] { "/cmd [option] <para1> <para2>      ", "eg: /cmd -reload           :Reload the command system.", "    /cmd -list             :Display all commands." })]
    public class CommandMgrSetupCommand : AbstractCommandHandler, ICommandHandler
    {
        public bool OnCommand(BaseClient client, string[] args)
        {
            if (args.Length > 1)
            {
                switch (args[1])
                {
                    case "-reload":
                        CommandMgr.LoadCommands();
                        break;
                    case "-list":
                        CommandMgr.DisplaySyntax(client);
                        break;
                    default:
                        this.DisplaySyntax(client);
                        break;
                }
            }
            else
                this.DisplaySyntax(client);
            return true;
        }
    }
}
