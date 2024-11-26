using Godot;
using System;
using System.Text;

public class WebSocketClient : Node
{
	private WebSocketPeer _webSocketPeer;  // Usamos WebSocketPeer para la conexión real
	private bool _isConnected = false;

	// Eventos que se activan cuando ocurre algún cambio en el WebSocket
	public event Action OnConnectionEstablished;
	public event Action OnConnectionError;
	public event Action OnConnectionClosed;
	public event Action<byte[]> OnDataReceived;

	// Método para conectar al servidor WebSocket
	public void ConnectToServer(string url)
	{
		_webSocketPeer = new WebSocketPeer();  // Usamos WebSocketPeer

		// Conectamos las señales
		_webSocketPeer.Connect("connection_established", this, nameof(OnConnectionEstablishedHandler));
		_webSocketPeer.Connect("connection_error", this, nameof(OnConnectionErrorHandler));
		_webSocketPeer.Connect("data_received", this, nameof(OnDataReceivedHandler));
		_webSocketPeer.Connect("connection_closed", this, nameof(OnConnectionClosedHandler));

		var error = _webSocketPeer.ConnectToUrl(url);  // Establece la conexión
		if (error != Error.Ok)
		{
			GD.Print($"Error al conectar al WebSocket: {error}");
		}
		else
		{
			GD.Print("Conectando al WebSocket...");
		}
	}

	// Método para enviar un mensaje al servidor
	public void SendMessage(string message)
	{
		if (!_isConnected)
		{
			GD.Print("No estamos conectados.");
			return;
		}

		byte[] messageBytes = Encoding.UTF8.GetBytes(message);
		_webSocketPeer.PutPacket(messageBytes);  // Enviamos el paquete con el mensaje
	}

	// Método para hacer polling (necesario para mantener la conexión)
	public void Poll()
	{
		if (_isConnected)
		{
			_webSocketPeer.Poll();  // Polling para mantener la conexión
		}
	}

	// Métodos para manejar las señales de conexión
	private void OnConnectionEstablishedHandler()
	{
		GD.Print("Conexión establecida.");
		_isConnected = true;
		OnConnectionEstablished?.Invoke();
	}

	private void OnConnectionErrorHandler()
	{
		GD.Print("Error de conexión.");
		_isConnected = false;
		OnConnectionError?.Invoke();
	}

	private void OnDataReceivedHandler()
	{
		var packet = _webSocketPeer.GetPacket();
		OnDataReceived?.Invoke(packet);
	}

	private void OnConnectionClosedHandler()
	{
		GD.Print("Conexión cerrada.");
		_isConnected = false;
		OnConnectionClosed?.Invoke();
	}
}
