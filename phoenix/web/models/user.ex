defmodule EcPredictions.User do
  use EcPredictions.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :favourites, EcPredictions.Favourite
    has_many :qualifieds, EcPredictions.Qualified
    has_many :predictions, EcPredictions.Prediction

    has_one :score, EcPredictions.Score

    timestamps
  end

  @doc """
  Builds a changeset based on the `user` and `params`.
  """
  def changeset(user, params \\ %{}) do
    user
    |> base_changeset(params)
    |> cast(params, [:password])
    |> put_pass_hash_if_changed_and_valid()
  end

  @doc """
  Changeset for registering a user
  """
  def registration_changeset(user, params \\ %{}) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
    |> put_assoc(:score, EcPredictions.Score.new)
  end

  defp base_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email, :name])
    |> validate_required([:email, :name])
    |> unique_constraint(:email)
  end

  defp put_pass_hash(cs) do
    case cs do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(cs, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        cs
    end
  end

  # Update the password if it is not the empty string
  defp put_pass_hash_if_changed_and_valid(cs) do
    case cs do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        case pass do
          "" ->
            cs
          _ ->
            cs
            |> validate_length(:password, min: 6, max: 100)
            |> put_pass_hash()
        end
      _ ->
        cs
    end
  end
end
