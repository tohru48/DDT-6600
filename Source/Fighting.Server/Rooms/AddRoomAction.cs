// Decompiled with JetBrains decompiler
// Type: Fighting.Server.Rooms.AddRoomAction
// Assembly: Fighting.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 73143BA9-1DDF-481C-AA0E-6BDD7564C4BE
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\fight\Fighting.Server.dll

#nullable disable
namespace Fighting.Server.Rooms
{
  public class AddRoomAction : IAction
  {
    private ProxyRoom proxyRoom_0;

    public AddRoomAction(ProxyRoom room) => this.proxyRoom_0 = room;

    public void Execute()
    {
      ProxyRoomMgr.AddRoomUnsafe(this.proxyRoom_0);
      if (!this.proxyRoom_0.startWithNpc)
        return;
      ProxyRoomMgr.StartWithNpcUnsafe(this.proxyRoom_0);
    }
  }
}
