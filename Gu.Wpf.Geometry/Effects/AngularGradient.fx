#include <shared.hlsli>
static float4 transparent = float4(0, 0, 0, 0);

sampler2D inputSampler : register(S0);

/// <summary>The primary color of the gradient. </summary>
/// <defaultValue>Blue</defaultValue>
float4 StartColor : register(C0);

/// <summary>The secondary color of the gradient. </summary>
/// <defaultValue>Red</defaultValue>
float4 EndColor : register(C1);

/// <summary>The center of the gradient, default is 0.5, 0.5.</summary>
/// <minValue>0,0</minValue>
/// <maxValue>1,1</maxValue>
/// <defaultValue>.5,.5</defaultValue>
float2 CenterPoint : register(C2);

/// <summary>The starting angle of the gradient, clockwise from X-axis</summary>
/// <minValue>-360</minValue>
/// <maxValue>360</maxValue>
/// <defaultValue>0</defaultValue>
float StartAngle : register(C3);

/// <summary>The central angle of the gradient, positive value for clockwise.</summary>
/// <minValue>-360</minValue>
/// <maxValue>360</maxValue>
/// <defaultValue>360</defaultValue>
float CentralAngle : register(C4);

float4 main(float2 uv : TEXCOORD) : COLOR
{
    float4 sc = tex2D(inputSampler, uv);
    if (abs(CentralAngle) < 0.01 ||
        sc.a == 0)
    {
        return transparent;
    }

    float sa = radians(StartAngle);
    float ca = radians(CentralAngle);
    float4 rgba = lerp_rgba(
                    StartColor,
                    EndColor,
                    interpolate(
                        0,
                        abs(ca),
                        angle_from_start(uv, CenterPoint, sa, ca)));
    rgba.a = min(rgba.a, sc.a);
    return rgba;
}
