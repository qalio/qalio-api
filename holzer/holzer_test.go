package holzer

import "testing"

func TestInit(t *testing.T) {
	expected := "holzer module initialized"
	if got := Init(); got != expected {
		t.Errorf("Init() = %q, want %q", got, expected)
	}
}
