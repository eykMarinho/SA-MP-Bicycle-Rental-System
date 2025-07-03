# Sistema de Aluguel de Veículos para SA-MP


## 📋 Descrição

Sistema de aluguel de veículos para servidores SA-MP. Este sistema permite que jogadores aluguem bicicletas em pontos específicos do mapa, com cobrança por minuto e tempo máximo de uso.

## ✨ Funcionalidades

- Pontos de aluguel configuráveis pelo mapa
- Sistema de cobrança por minuto
- Tempo máximo de aluguel configurável
- Comandos para alugar (`/Alugar`) e devolver (`/Devolver`) veículos
- Texto 3D informativo sobre o veículo alugado
- Ícones no mapa para localizar pontos de aluguel

## 📦 Dependências

Este sistema requer as seguintes dependências:

### Streamer Plugin v2.9.6 v1.0.0
- Download: [GitHub - samp-incognito/samp-streamer-plugin](https://github.com/samp-incognito/samp-streamer-plugin/releases)

### YSI-Includes
- Download: [GitHub - pawn-lang/YSI-Includes](https://github.com/pawn-lang/YSI-Includes)

### Pawn.CMD 3.4.0
- Download: [GitHub - katursis/Pawn.CMD](https://github.com/katursis/Pawn.CMD/releases)

## 🔧 Configuração

Você pode configurar o sistema editando as seguintes constantes no início do arquivo:

```pawn
#define RENT_LIMITS_POINTS      2       // Número de pontos de aluguel
#define RENT_PRICE_PER_MINUTE   50      // Preço por minuto
#define MAX_RENT_TIME           60      // Tempo máximo em minutos
#define RENT_PICKUP_MODEL       1239    // Modelo do pickup
#define RENT_MAPICON_MODEL      55      // Modelo do ícone no mapa
#define RENT_VEHICLE_MODEL      509     // Modelo do veículo (509 = Bicicleta)
#define RENT_VEHICLE_COLOR_ID   3       // Cor do veículo (3 = Vermelho)
```

Para adicionar ou modificar pontos de aluguel, edite o array `RentVehicles`:

```pawn
static RentVehicles[RENT_LIMITS_POINTS][E_RENT_VEHICLE] = 
{
    {126.8853,-77.1170,1.5781},
    {140.7119,-80.0326,1.5781}
};
```

## 📝 Comandos

- `/Alugar` - Aluga uma bicicleta (deve estar próximo a um ponto de aluguel)
- `/Devolver` - Devolve a bicicleta alugada

## 👨‍💻 Desenvolvido por

- MARINHO
- GitHub: [eykMarinho](https://github.com/eykMarinho)
- YouTube: [@eykMarinho](https://www.youtube.com/@eykMarinho)

## 📄 Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para mais detalhes.
