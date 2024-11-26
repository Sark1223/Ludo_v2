using Godot;
using System;
using System.Text.Json;

public partial class Main : Node
{
	private WebSocketClient _webSocketClient;  // Debes inicializar el WebSocketClient correctamente
	private bool _isConnected = false;

	public override void _Ready()
	{
		// Inicializamos el WebSocketClient
		_webSocketClient = new WebSocketClient();

		// Conectamos los eventos de WebSocketClient
		_webSocketClient.OnConnectionEstablished += OnConnectionEstablished;
		_webSocketClient.OnConnectionError += OnConnectionError;
		_webSocketClient.OnConnectionClosed += OnConnectionClosed;
		_webSocketClient.OnDataReceived += OnDataReceived;

		// Conectamos al servidor WebSocket
		_webSocketClient.ConnectToServer("ws://127.0.0.1:8080");  // Reemplaza con tu URL real
	}

	public override void _Process(double delta)
	{
		// Realizamos polling si estamos conectados
		if (_isConnected)
		{
			_webSocketClient.Poll();
		}
	}

	// Método cuando la conexión se establece correctamente
	private void OnConnectionEstablished()
	{
		GD.Print("Conexión establecida con el servidor WebSocket.");
		_isConnected = true;

		// Enviar un mensaje de ejemplo cuando se establece la conexión
		SendMessage("join_room", new JsonObject
		{
			["player_name"] = "Jugador1",
			["room_code"] = "ABC123"
		});
	}

	// Método cuando hay un error en la conexión
	private void OnConnectionError()
	{
		GD.Print("Error al conectar con el servidor WebSocket.");
		_isConnected = false;
	}

	// Método cuando se recibe datos del servidor WebSocket
	private void OnDataReceived(byte[] packet)
	{
		var jsonString = System.Text.Encoding.UTF8.GetString(packet);
		GD.Print("Mensaje recibido: " + jsonString);

		// Procesamos la respuesta del servidor
		ProcessServerResponse(jsonString);
	}

	// Método cuando la conexión se cierra
	private void OnConnectionClosed()
	{
		GD.Print("Conexión cerrada con el servidor.");
		_isConnected = false;
	}

	// Método para procesar la respuesta del servidor (JSON)
	private void ProcessServerResponse(string response)
	{
		try
		{
			var json = JsonSerializer.Deserialize<JsonElement>(response);
			var status = json.GetProperty("status").GetString();

			// Procesamos la respuesta según el valor del campo "status"
			switch (status)
			{
				case "room_created":
					GD.Print("Sala creada: ", json.GetProperty("room_code").GetString());
					break;

				case "joined":
					GD.Print("Te uniste a la sala.");
					break;

				case "failed":
					GD.Print("No se pudo unir a la sala.");
					break;

				case "started":
					GD.Print("El juego ha comenzado.");
					break;

				case "waiting_for_players":
					GD.Print("Esperando más jugadores...");
					break;

				case "new_message":
					GD.Print($"Nuevo mensaje de {json.GetProperty("from").GetString()}: {json.GetProperty("message").GetString()}");
					break;

				default:
					GD.Print("Comando desconocido: ", status);
					break;
			}
		}
		catch (Exception ex)
		{
			GD.Print("Error procesando respuesta del servidor: ", ex.Message);
		}
	}

	// Función para enviar mensajes al servidor WebSocket
	private void SendMessage(string command, JsonElement content)
	{
		// Verificamos si estamos conectados antes de intentar enviar un mensaje
		if (!_isConnected)
		{
			GD.Print("No hay conexión activa con el servidor.");
			return;
		}

		// Creamos un objeto anónimo para el mensaje
		var message = new
		{
			command,  // Nombre del comando (por ejemplo: "join_room", "start_game", etc.)
			content   // El contenido de la petición (generalmente un JsonElement)
		};

		// Serializamos el objeto a un string JSON
		var jsonMessage = JsonSerializer.Serialize(message);

		// Convertimos el mensaje a un array de bytes usando UTF-8
		byte[] bytes = Encoding.UTF8.GetBytes(jsonMessage);

		// Enviamos el paquete con el mensaje al servidor WebSocket
		_webSocketClient.SendMessage(jsonMessage);

		GD.Print("Mensaje enviado: " + jsonMessage);
	}

	// Función para crear una nueva sala
	public void CreateRoom(string playerName)
	{
		var content = JsonDocument.Parse($"{{\"player_name\": \"{playerName}\"}}").RootElement;
		SendMessage("create_room", content);
	}

	// Función para unirse a una sala existente
	public void JoinRoom(string roomCode, string playerName)
	{
		var content = JsonDocument.Parse($"{{\"room_code\": \"{roomCode}\", \"player_name\": \"{playerName}\"}}").RootElement;
		SendMessage("join_room", content);
	}

	// Función para iniciar el juego
	public void StartGame(string roomCode)
	{
		var content = JsonDocument.Parse($"{{\"room_code\": \"{roomCode}\"}}").RootElement;
		SendMessage("start_game", content);
	}

	// Función para enviar un mensaje de chat
	public void SendChatMessage(string roomCode, string playerName, string messageContent)
	{
		var content = JsonDocument.Parse($"{{\"room_code\": \"{roomCode}\", \"player_name\": \"{playerName}\", \"message\": \"{messageContent}\"}}").RootElement;
		SendMessage("send_message", content);
	}
}
