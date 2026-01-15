// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.ProcessPacketAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Cmd;
using Game.Logic.Phy.Object;
using log4net;
using System;
using System.Reflection;

#nullable disable
namespace Game.Logic.Actions
{
  public class ProcessPacketAction : IAction
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private Player player_0;
    private GSPacketIn gspacketIn_0;

    public ProcessPacketAction(Player player, GSPacketIn pkg)
    {
      this.player_0 = player;
      this.gspacketIn_0 = pkg;
    }

    public void Execute(BaseGame game, long tick)
    {
      if (!this.player_0.IsActive)
        return;
      eTankCmdType code = (eTankCmdType) this.gspacketIn_0.ReadByte();
      try
      {
        ICommandHandler commandHandler = CommandMgr.LoadCommandHandler((int) code);
        if (commandHandler != null)
          commandHandler.HandleCommand(game, this.player_0, this.gspacketIn_0);
        else
          ProcessPacketAction.ilog_0.Error((object) string.Format("Player Id: {0}", (object) this.player_0.Id));
      }
      catch (Exception ex)
      {
        ProcessPacketAction.ilog_0.Error((object) string.Format("Player Id: {0}  cmd:0x{1:X2}", (object) this.player_0.Id, (object) (byte) code), ex);
      }
    }

    public bool IsFinished(long tick) => true;
  }
}
